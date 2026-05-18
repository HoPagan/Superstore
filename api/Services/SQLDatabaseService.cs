using System.Data;
using Microsoft.Data.SqlClient;

namespace api.Services;

// A centralized service for executing stored procedures.
// Inject this wherever you need database access instead of writing
// raw ADO.NET connection/command code in every controller.
//
// It implements IDatabaseService so controllers depend on the
// interface, not this concrete class.
public class SQLDatabaseService : IDatabaseService
{
    private readonly string _connectionString;

    public SQLDatabaseService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("Superstore")
            ?? throw new InvalidOperationException("Connection string 'Superstore' not found.");
    }

    // Execute a stored procedure and return every row as a dictionary.
    // Pass an empty array (or nothing) when the proc needs no parameters.
    //
    // Usage – no params:
    //   var rows = await _db.QueryAsync("GetAllAddresses");
    //
    // Usage – with params:
    //   var rows = await _db.QueryAsync("GetAddress",
    //       new SqlParameter("@AddressID", id));
    public async Task<List<Dictionary<string, object?>>> QueryAsync(
        string storedProcedure,
        params SqlParameter[] parameters)
    {
        var results = new List<Dictionary<string, object?>>();

        using SqlConnection connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using SqlCommand command = new SqlCommand(storedProcedure, connection);
        command.CommandType = CommandType.StoredProcedure;

        if (parameters.Length > 0)
            command.Parameters.AddRange(parameters);

        using SqlDataReader reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            // Turn each row into a simple name → value dictionary
            var row = new Dictionary<string, object?>();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                string column = reader.GetName(i);
                object? value = reader.IsDBNull(i) ? null : reader.GetValue(i);
                row[column] = value;
            }
            results.Add(row);
        }

        return results;
    }

    // Convenience helper for queries that return exactly one row.
    // Returns null if the stored procedure produces no rows.
    public async Task<Dictionary<string, object?>?> QuerySingleAsync(
        string storedProcedure,
        params SqlParameter[] parameters)
    {
        var rows = await QueryAsync(storedProcedure, parameters);
        return rows.Count > 0 ? rows[0] : null;
    }

    // Execute a stored procedure that does not return rows (INSERT / UPDATE / DELETE).
    // Returns the number of rows affected.
    public async Task<int> ExecuteAsync(
        string storedProcedure,
        params SqlParameter[] parameters)
    {
        using SqlConnection connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using SqlCommand command = new SqlCommand(storedProcedure, connection);
        command.CommandType = CommandType.StoredProcedure;

        if (parameters.Length > 0)
            command.Parameters.AddRange(parameters);

        return await command.ExecuteNonQueryAsync();
    }
}