/// Decides which stored entry a save from the editor writes to, and whether it
/// should write at all.
///
/// Editing a saved entry is non-destructive: a draft save branches a new entry
/// and keeps the original as its `originalId`, so the saved entry stays intact
/// until the user presses Done. The branched id has to be stable for the sheet's
/// lifetime — minting a fresh one on every autosave would add another copy to
/// Drafts every two seconds.
class SaveTargetResolver {
  String? _branchedId;
  String? _branchedFrom;

  /// Works out the id, the `originalId` and any draft to remove.
  ///
  /// [currentId] is the sheet's own id. [entryId], [entryIsDraft] and
  /// [entryOriginalId] describe the entry the sheet was opened on, or are null
  /// for a new entry. [newId] mints an id and is called at most once per sheet,
  /// however many drafts are saved.
  SaveTargetDecision resolve({
    required String currentId,
    required String? entryId,
    required bool entryIsDraft,
    required String? entryOriginalId,
    required bool isDraft,
    required String Function() newId,
  }) {
    // A draft of a saved entry: branch once, then keep writing to that branch.
    if (isDraft && entryId != null && !entryIsDraft) {
      if (_branchedId != null && _branchedFrom == entryId) {
        return SaveTargetDecision(id: _branchedId!, originalId: entryId);
      }
      final branched = newId();
      _branchedId = branched;
      _branchedFrom = entryId;
      return SaveTargetDecision(id: branched, originalId: entryId);
    }

    // Done on a branched draft: write the original back and drop the branch.
    if (!isDraft && entryId != null && entryIsDraft && entryOriginalId != null) {
      return SaveTargetDecision(id: entryOriginalId, draftToDelete: entryId);
    }

    // Done on an entry that was never branched: write it where it lives. The
    // sheet's own id is the same value in practice; taking it from the entry
    // keeps the two from drifting apart.
    if (entryId != null && !entryIsDraft) {
      return SaveTargetDecision(id: entryId);
    }

    return SaveTargetDecision(id: currentId);
  }

  /// The branch this sheet minted, so a discard can remove it.
  String? get branchedDraftId => _branchedId;
}

/// What a save should write.
class SaveTargetDecision {
  const SaveTargetDecision({
    required this.id,
    this.originalId,
    this.draftToDelete,
  });

  /// The id the entry is written under.
  final String id;

  /// The saved entry this one branched from, if any.
  final String? originalId;

  /// A branched draft that this save replaces and should be removed.
  final String? draftToDelete;
}

/// Whether there is anything worth writing.
///
/// Mirrors the rule in `HiveService.updateJournalEntry`: an entry with no text
/// and no media is not an entry. A draft save that reaches the box with nothing
/// in it leaves a blank entry behind, and the user cannot delete it, because
/// Done refuses to save an empty entry.
bool journalHasContent({
  required bool isTextEmpty,
  required bool isMediaEmpty,
}) {
  return !(isTextEmpty && isMediaEmpty);
}