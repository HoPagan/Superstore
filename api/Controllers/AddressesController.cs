using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using api.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AddressesController : ControllerBase
{
    private readonly IDatabaseService _db;

    public AddressesController(IDatabaseService db)
    {
        _db = db;
    }

    // 1. READ ALL BY CUSTOMER: GET /api/addresses?customerId=1
    [HttpGet(Name = "GetAddresses")]
    public async Task<IActionResult> Get([FromQuery] int customerId)
    {
        try
        {
            var parameters = new[] { new SqlParameter("@CustomerID", customerId) };
            List<Dictionary<string, object?>> rows = await _db.QueryAsync("GetAllAddresses", parameters);
            List<Address> addresses = rows.Select(MapFromDictionary).ToList();
            
            return Ok(addresses);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // 2. READ SINGLE: GET /api/addresses/{id}
    [HttpGet("{id}", Name = "GetAddressById")]
    public async Task<IActionResult> GetById(int id)
    {
        try
        {
            var parameters = new[] { new SqlParameter("@AddressID", id) };
            var row = await _db.QuerySingleAsync("GetAddress", parameters);
            
            if (row == null) 
                return NotFound($"Address with ID {id} not found.");

            Address address = MapFromDictionary(row);
            return Ok(address);      
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // 3. CREATE: POST /api/addresses
    [HttpPost]
    public async Task<IActionResult> Post([FromBody] AddressInput model)
    {
        try
        {
            var parameters = new[]
            {
                new SqlParameter("@AddressLine1", model.AddressLine1),
                new SqlParameter("@AddressLine2", model.AddressLine2 ?? (object)DBNull.Value),
                new SqlParameter("@City", model.City),
                new SqlParameter("@StateID", model.StateID),
                new SqlParameter("@CountryID", model.CountryID),
                new SqlParameter("@PostalCode", model.PostalCode),
                new SqlParameter("@RegionID", model.RegionID),
                new SqlParameter("@AddressTypeID", model.AddressTypeID),
                new SqlParameter("@CustomerID", model.CustomerID)
            };

            // Using QuerySingleAsync because 'CreateAddress' uses ExecuteScalar to return the new numeric primary key ID
            var row = await _db.QuerySingleAsync("CreateAddress", parameters);
            return Ok(new { message = "Address created successfully", data = row });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // 4. UPDATE: PUT /api/addresses/{id}
    [HttpPut("{id}")]
    public async Task<IActionResult> Put(int id, [FromBody] AddressInput model)
    {
        try
        {
            var parameters = new[]
            {
                new SqlParameter("@AddressID", id),
                new SqlParameter("@AddressLine1", model.AddressLine1 ?? (object)DBNull.Value),
                new SqlParameter("@AddressLine2", model.AddressLine2 ?? (object)DBNull.Value),
                new SqlParameter("@City", model.City ?? (object)DBNull.Value),
                new SqlParameter("@StateID", model.StateID == 0 ? (object)DBNull.Value : model.StateID),
                new SqlParameter("@CountryID", model.CountryID == 0 ? (object)DBNull.Value : model.CountryID),
                new SqlParameter("@PostalCode", model.PostalCode == 0 ? (object)DBNull.Value : model.PostalCode),
                new SqlParameter("@RegionID", model.RegionID == 0 ? (object)DBNull.Value : model.RegionID),
                new SqlParameter("@AddressTypeID", model.AddressTypeID == 0 ? (object)DBNull.Value : model.AddressTypeID),
                new SqlParameter("@CustomerID", model.CustomerID == 0 ? (object)DBNull.Value : model.CustomerID)
            };

            await _db.ExecuteAsync("UpdateAddress", parameters);
            return Ok(new { message = "Address updated successfully" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // 5. DELETE: DELETE /api/addresses/{id}
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        try
        {
            var parameters = new[]
            {
                new SqlParameter("@AddressID", id),
                new SqlParameter("@Delete", 1)
            };

            await _db.ExecuteAsync("DeleteAddress", parameters);
            return Ok(new { message = "Address removed successfully" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    // Modern mapping framework connecting decoupled result payloads into objects securely
    private static Address MapFromDictionary(Dictionary<string, object?> row)
    {
        return new Address
        {
            AddressID = Convert.ToInt32(row["AddressID"]),
            AddressLine1 = Convert.ToString(row["AddressLine1"]) ?? string.Empty,
            AddressLine2 = row.ContainsKey("AddressLine2") && row["AddressLine2"] != null ? Convert.ToString(row["AddressLine2"]) ?? string.Empty : string.Empty,
            City = Convert.ToString(row["City"]) ?? string.Empty,
            State = row.ContainsKey("State") ? Convert.ToString(row["State"]) ?? string.Empty : string.Empty,
            PostalCode = Convert.ToInt32(row["PostalCode"]),
            Country = row.ContainsKey("Country") ? Convert.ToString(row["Country"]) ?? string.Empty : string.Empty,
            Region = row.ContainsKey("Region") ? Convert.ToString(row["Region"]) ?? string.Empty : string.Empty,
            AddressType = row.ContainsKey("AddressType") ? Convert.ToString(row["AddressType"]) ?? string.Empty : string.Empty,
            CustomerID = Convert.ToInt32(row["CustomerID"])
        };
    }
}

// Complete Data Transport Payloads 
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
    public string State { get; set; } = string.Empty;
    public int PostalCode { get; set; }
    public string Country { get; set; } = string.Empty;
    public string Region { get; set; } = string.Empty;
    public string AddressType { get; set; } = string.Empty;
    public int CustomerID { get; set; }
}
