/// Classe per gestire il risultato di operazioni che possono fallire
/// in modo type-safe senza usare eccezioni per il flusso di controllo.
class Result<T> {
  final T? data;
  final String? errorMessage;
  final Exception? exception;

  bool get isSuccess => data != null && errorMessage == null;
  bool get isFailure => !isSuccess;

  const Result.success(this.data)
      : errorMessage = null,
        exception = null;

  const Result.failure(this.errorMessage, [this.exception]) : data = null;

  /// Esegue una funzione se il risultato è un successo
  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess) {
      try {
        return Result.success(transform(data as T));
      } catch (e) {
        return Result.failure('Errore durante la trasformazione: $e');
      }
    }
    return Result.failure(errorMessage!, exception);
  }

  /// Esegue una funzione in caso di fallimento
  Result<T> onFailure(void Function(String error) callback) {
    if (isFailure) {
      callback(errorMessage!);
    }
    return this;
  }

  /// Esegue una funzione in caso di successo
  Result<T> onSuccess(void Function(T data) callback) {
    if (isSuccess) {
      callback(data as T);
    }
    return this;
  }
}
