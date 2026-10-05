enum UpdateGateStatus { upToDate, blocked, updating }

final class UpdateGateResult {
  const UpdateGateResult(this.status, {this.storeUrl, this.message});

  final UpdateGateStatus status;
  final String? storeUrl;
  final String? message;
}
