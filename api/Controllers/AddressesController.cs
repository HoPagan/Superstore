using Microsoft.AspNetCore.Mvc;

namespace api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AddressesController : ControllerBase
{
    [HttpGet(Name = "GetAddresses")]
    public IActionResult Get()
    {
        return Ok(new List<Address>
        {
                new Address
                {
                    AddressID = 1,
                    AddressLine1 = "123 Main Street - 1",
                    AddressLine2 = "Address Line 2 - 1",
                    City = "City 1",
                    StateID = 1,
                    State = "State 1",
                    PostalCode = 10001,
                    Country = "Country 1",
                    CountyID = 1,
                    Region = "Region 1",
                    RegionID = 1,
                    AddressType = "Address Type 1",
                    CustomerID = 1,
                    CustomerTypeID = 1
                }, 
                new Address
                {
                    AddressID = 2,
                    AddressLine1 = "456 Oak Avenue - 2",
                    AddressLine2 = "Address Line 2 - 2",
                    City = "City 2",
                    StateID = 2,
                    State = "State 2",
                    PostalCode = 10002,
                    Country = "Country 2",
                    CountyID = 2,
                    Region = "Region 2",
                    RegionID = 2,
                    AddressType = "Address Type 2",
                    CustomerID = 2,
                    CustomerTypeID = 2
                }
        });
    }
}