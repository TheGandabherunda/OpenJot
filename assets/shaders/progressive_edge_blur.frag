#version 460 core
#include <flutter/runtime_effect.glsl>

// Performance-friendly single-pass-per-axis progressive Gaussian blur.
// Uses hardware bilinear tap pairing and early Gaussian tail exit so there
// are zero periodic grid artifacts and minimal GPU cost during 120Hz scroll.

uniform vec2 u_size;      // input texture size in physical pixels
uniform vec4 u_band;      // band rect in physical pixels: x, y, width, height
uniform float u_sigma;    // max blur sigma at the outer edge (physical pixels)
uniform float u_vertical; // 0.0 = horizontal pass, 1.0 = vertical pass
uniform float u_edge;     // 0 = top, 1 = bottom, 2 = left, 3 = right
uniform vec4 u_curve0;    // falloff curve samples t = 0/7 .. 3/7
uniform vec4 u_curve1;    // falloff curve samples t = 4/7 .. 7/7
uniform vec4 u_tint;      // premultiplied tint color (r*a, g*a, b*a, a)

uniform sampler2D u_texture;

out vec4 frag_color;

// 28 paired taps = 56 underlying texel positions per side.
const int PAIR_TAPS = 28;

float strength(float t) {
  float x = clamp(t, 0.0, 1.0) * 7.0;
  vec4 lo = max(vec4(0.0), 1.0 - abs(vec4(x) - vec4(0.0, 1.0, 2.0, 3.0)));
  vec4 hi = max(vec4(0.0), 1.0 - abs(vec4(x) - vec4(4.0, 5.0, 6.0, 7.0)));
  return clamp(dot(u_curve0, lo) + dot(u_curve1, hi), 0.0, 1.0);
}

// Returns 1.0 at the outer blurred edge and 0.0 at the inner edge.
float progress(vec2 p) {
  vec2 local = (p - u_band.xy) / u_band.zw;
  if (u_edge < 0.5) return clamp(1.0 - local.y, 0.0, 1.0);
  if (u_edge < 1.5) return clamp(local.y, 0.0, 1.0);
  if (u_edge < 2.5) return clamp(1.0 - local.x, 0.0, 1.0);
  return clamp(local.x, 0.0, 1.0);
}

void main() {
  vec2 p = FlutterFragCoord().xy;
  vec2 uv = p / u_size;
#ifdef IMPELLER_TARGET_OPENGLES
  uv.y = 1.0 - uv.y;
#endif

  vec2 halfTexel = 0.5 / u_size;
  vec2 minUv = halfTexel;
  vec2 maxUv = vec2(1.0) - halfTexel;
  uv = clamp(uv, minUv, maxUv);

  float s = strength(progress(p));
  float sigma = u_sigma * s;

  vec4 color = texture(u_texture, uv);
  if (sigma >= 0.3) {
    vec2 dir = (u_vertical > 0.5 ? vec2(0.0, 1.0) : vec2(1.0, 0.0)) / u_size;
    // Keep spacing <= ~1.9 texels so hardware bilinear filtering prevents any grid pattern.
    float step = max(1.0, (2.25 * sigma) / float(PAIR_TAPS * 2));
    float k = -0.5 / (sigma * sigma);

    vec4 sum = color;
    float weights = 1.0;
    for (int i = 1; i <= PAIR_TAPS; i++) {
      float x0 = float(2 * i - 1) * step;
      float x1 = float(2 * i) * step;
      float w0 = exp(x0 * x0 * k);
      float w1 = exp(x1 * x1 * k);
      float w = w0 + w1;
      if (w < 0.002) {
        break;
      }
      float offset = (x0 * w0 + x1 * w1) / w;
      vec2 d = dir * offset;
      vec2 uv_pos = clamp(uv + d, minUv, maxUv);
      vec2 uv_neg = clamp(uv - d, minUv, maxUv);
      sum += (texture(u_texture, uv_pos) + texture(u_texture, uv_neg)) * w;
      weights += 2.0 * w;
    }
    color = sum / weights;
  }

  if (u_vertical > 0.5 && u_tint.a > 0.0) {
    // Concentrate subtle tint strictly at the extreme edge without any visible cutoff line.
    float tintFactor = s * s * s;
    color = color * (1.0 - u_tint.a * tintFactor) + u_tint * tintFactor;
  }
  frag_color = color;
}
