using System.Data;
using api.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CategoriesController : ControllerBase
{
    private readonly IDatabaseService _db;

    public CategoriesController(IDatabaseService db)
    {
        _db = db;
    }

    [HttpGet(Name = "GetAllCategories")]
    public async Task<IActionResult> Get()
    {
        try
        {
            List<Dictionary<string, object?>> rows = await _db.QueryAsync("GetAllCategories");
            List<Category> categories = rows.Select(MapToCategory).ToList();

            return Ok(categories);
        }
        catch (Exception ex)
        {
            // Log the exception (not shown here)
            return StatusCode(500, $"An error occurred while processing your request for all categories: {ex.Message}");
        }
    }

    private static Category MapToCategory(Dictionary<string, object?> row) => new Category
    {
        CategoryID = Convert.ToInt32(row["CategoryID"]),
        CategoryName = Convert.ToString(row["Category"]) ?? string.Empty
    };
}