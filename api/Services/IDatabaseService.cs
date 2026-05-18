using Microsoft.Data.SqlClient;

namespace api.Services;

// This interface describes WHAT the database service can do,
// without saying HOW it does it.
//
// Controllers depend on this interface, not on the concrete class.
// That means you could swap DatabaseService for a mock in tests
// without changing any controller code — that's the power of DI.
public interface IDatabaseService
{
    // Returns all rows from a stored procedure as a list of dictionaries
    Task<List<Dictionary<string, object?>>> QueryAsync(
        string storedProcedure,
        params SqlParameter[] parameters);

    // Returns a single row, or null if no rows were found
    Task<Dictionary<string, object?>?> QuerySingleAsync(
        string storedProcedure,
        params SqlParameter[] parameters);

    // Runs an INSERT / UPDATE / DELETE proc and returns rows affected
    Task<int> ExecuteAsync(
        string storedProcedure,
        params SqlParameter[] parameters);
}