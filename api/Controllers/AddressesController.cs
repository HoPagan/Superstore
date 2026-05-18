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

    public AddressesController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    [HttpGet(Name = "GetAddresses")]
    public IActionResult Get()
    {
        return Ok(new List<Address>
        {
            new Address
            {
                AddressID = 1,
                AddressLine1 = "123 Main St",
                City = "Anytown",
                StateID = 1,
                State = "StateName",
                PostalCode = 12345,
                CountryID = 1,
                Country = "CountryName",
                RegionID = 1,
                Region = "RegionName",
                AddressTypeID = 1,
                AddressType = "Home",
                CustomerID = 1
            },
            new Address
            {
                AddressID = 2,
                AddressLine1 = "456 Elm St",
                City = "Othertown",
                StateID = 2,
                State = "OtherState",
                PostalCode = 67890,
                CountryID = 2,
                Country = "OtherCountry",
                RegionID = 2,
                Region = "OtherRegion",
                AddressTypeID = 2,
                AddressType = "Work",
                CustomerID = 2
            }
        });
    }

    [HttpGet("{id}", Name = "GetAddressById")]
    public IActionResult Get(int id)
    {
        try
        {
            Address address = new Address();

            // get connetion string from appsettings.json
            string? connectionString = _configuration.GetConnectionString("Superstore");
            // open connection to the database
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                // inside connection, execute a stored procedure to get the address by id    
                SqlCommand command = new SqlCommand("GetAddress", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@AddressID", id);
                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    // map the result to the address object
                    address.AddressID = (int)reader["AddressID"];
                    address.AddressLine1 = reader["AddressLine1"].ToString() ?? string.Empty;
                    address.AddressLine2 = reader["AddressLine2"].ToString() ?? string.Empty;
                    address.City = reader["City"].ToString() ?? string.Empty;
                    address.State = reader["State"].ToString() ?? string.Empty;
                    address.PostalCode = (int)reader["PostalCode"];
                    address.Country = reader["Country"].ToString() ?? string.Empty;
                    address.Region = reader["Region"].ToString() ?? string.Empty;
                    address.AddressType = reader["AddressType"].ToString() ?? string.Empty;
                    address.CustomerID = (int)reader["CustomerID"];
                }
            }

            return Ok(address);      
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }
}