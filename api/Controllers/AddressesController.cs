using System.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AddressesController : ControllerBase
{
    private readonly IConfiguration _configuration;
    private readonly string? _connectionString;

    public AddressesController(IConfiguration configuration)
    {
        _configuration = configuration;
        _connectionString = _configuration.GetConnectionString("Superstore");
    }

    // 1. READ ALL BY CUSTOMER: GET /api/addresses?customerId=1
    [HttpGet(Name = "GetAddresses")]
    public IActionResult Get([FromQuery] int customerId)
    {
        try
        {
            List<Address> addresses = new List<Address>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("GetAllAddresses", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@CustomerID", customerId);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        addresses.Add(MapFromReader(reader));
                    }
                }
            }
            return Ok(addresses);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // 2. READ SINGLE: GET /api/addresses/{id}
    [HttpGet("{id}", Name = "GetAddressById")]
    public IActionResult GetById(int id)
    {
        try
        {
            Address? address = null;

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("GetAddress", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@AddressID", id);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        address = MapFromReader(reader);
                    }
                }
            }

            if (address == null) return NotFound($"Address with ID {id} not found.");
            return Ok(address);      
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // 3. CREATE: POST /api/addresses
    [HttpPost]
    public IActionResult Post([FromBody] AddressInput model)
    {
        try
        {
            int newAddressId = 0;
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("CreateAddress", connection);
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@AddressLine1", model.AddressLine1);
                command.Parameters.AddWithValue("@AddressLine2", model.AddressLine2 ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@City", model.City);
                command.Parameters.AddWithValue("@StateID", model.StateID);
                command.Parameters.AddWithValue("@CountryID", model.CountryID);
                command.Parameters.AddWithValue("@PostalCode", model.PostalCode);
                command.Parameters.AddWithValue("@RegionID", model.RegionID);
                command.Parameters.AddWithValue("@AddressTypeID", model.AddressTypeID);
                command.Parameters.AddWithValue("@CustomerID", model.CustomerID);

                newAddressId = Convert.ToInt32(command.ExecuteScalar());
            }
            return Ok(new { message = "Address created successfully", addressId = newAddressId });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // 4. UPDATE: PUT /api/addresses/{id}
    [HttpPut("{id}")]
    public IActionResult Put(int id, [FromBody] AddressInput model)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("UpdateAddress", connection);
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@AddressID", id);
                command.Parameters.AddWithValue("@AddressLine1", model.AddressLine1 ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@AddressLine2", model.AddressLine2 ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@City", model.City ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@StateID", model.StateID == 0 ? (object)DBNull.Value : model.StateID);
                command.Parameters.AddWithValue("@CountryID", model.CountryID == 0 ? (object)DBNull.Value : model.CountryID);
                command.Parameters.AddWithValue("@PostalCode", model.PostalCode == 0 ? (object)DBNull.Value : model.PostalCode);
                command.Parameters.AddWithValue("@RegionID", model.RegionID == 0 ? (object)DBNull.Value : model.RegionID);
                command.Parameters.AddWithValue("@AddressTypeID", model.AddressTypeID == 0 ? (object)DBNull.Value : model.AddressTypeID);
                command.Parameters.AddWithValue("@CustomerID", model.CustomerID == 0 ? (object)DBNull.Value : model.CustomerID);

                command.ExecuteNonQuery();
            }
            return Ok(new { message = "Address updated successfully" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // 5. DELETE: DELETE /api/addresses/{id}
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("DeleteAddress", connection);
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@AddressID", id);
                command.Parameters.AddWithValue("@Delete", 1); // Triggers permanent/cascade check inside procedure

                command.ExecuteNonQuery();
            }
            return Ok(new { message = "Address removed successfully" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // Reusable data reader mapping utility to keep endpoints clean
    private static Address MapFromReader(SqlDataReader reader)
    {
        return new Address
        {
            AddressID = Convert.ToInt32(reader["AddressID"]),
            AddressLine1 = reader["AddressLine1"].ToString() ?? string.Empty,
            AddressLine2 = reader["AddressLine2"] != DBNull.Value ? reader["AddressLine2"].ToString() ?? string.Empty : string.Empty,
            City = reader["City"].ToString() ?? string.Empty,
            State = reader["State"].ToString() ?? string.Empty,
            PostalCode = Convert.ToInt32(reader["PostalCode"]),
            Country = reader["Country"].ToString() ?? string.Empty,
            Region = reader["Region"].ToString() ?? string.Empty,
            AddressType = reader["AddressType"].ToString() ?? string.Empty,
            CustomerID = Convert.ToInt32(reader["CustomerID"])
        };
    }
}

// Input Model for Binding payloads safely
public class AddressInput
{
    public string? AddressLine1 { get; set; }
    public string? AddressLine2 { get; set; }
    public string? City { get; set; }
    public int StateID { get; set; }
    public int CountryID { get; set; }
    public int PostalCode { get; set; }
    public int RegionID { get; set; }
    public int AddressTypeID { get; set; }
    public int CustomerID { get; set; }
}

public class Address
{
    public int AddressID { get; set; }
    public string AddressLine1 { get; set; } = string.Empty;
    public string AddressLine2 { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public int StateID { get; set; }
    public string State { get; set; } = string.Empty;
    public int PostalCode { get; set; }
    public int CountryID { get; set; }
    public string Country { get; set; } = string.Empty;
    public int RegionID { get; set; }
    public string Region { get; set; } = string.Empty;
    public int AddressTypeID { get; set; }
    public string AddressType { get; set; } = string.Empty;
    public int CustomerID { get; set; }
}
