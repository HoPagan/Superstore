using System.Data;
using api.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SubCategoriesController : ControllerBase
{
    private readonly IDatabaseService _db;

    public SubCategoriesController(IDatabaseService db)
    {
        _db = db;
    }

    [HttpGet(Name = "GetAllSubCategories")]
    public async Task<IActionResult> Get()
    {
        try
        {
            List<Dictionary<string, object?>> rows = await _db.QueryAsync("GetAllSubCategories");
            List<SubCategory> subCategories = rows.Select(MapToSubCategory).ToList();

            return Ok(subCategories);
        }
        catch (Exception ex)
        {
            // Log the exception (not shown here)
            return StatusCode(500, $"An error occurred while processing your request for all sub-categories: {ex.Message}");
        }
    }

    private static SubCategory MapToSubCategory(Dictionary<string, object?> row) => new SubCategory
    {
        SubCategoryID = Convert.ToInt32(row["SubCategoryID"]),
        SubCategoryName = Convert.ToString(row["SubCategory"]) ?? string.Empty
    };
}