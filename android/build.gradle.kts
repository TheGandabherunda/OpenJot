allprojects {
    repositories {
        google()
        mavenCentral()
    }
    plugins.withId("com.android.library") {
        dependencies {
            "implementation"("androidx.concurrent:concurrent-futures:1.2.0")
        }
    }
}

rootProject.layout.buildDirectory.set(rootProject.file("../build"))

subprojects {
    project.layout.buildDirectory.set(rootProject.layout.buildDirectory.dir(project.name))
}

subprojects {
    project.evaluationDependsOn(":app")
    configurations.all {
        resolutionStrategy {
            force("androidx.concurrent:concurrent-futures:1.2.0")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
