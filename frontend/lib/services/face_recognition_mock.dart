class FaceRecognitionMock {
  Future<bool> verifyIdentity() async {
    await Future.delayed(const Duration(seconds: 1));
    return true; // pretend face recognition success
  }
}
