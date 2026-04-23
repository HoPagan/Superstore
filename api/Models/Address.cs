class Address
{
     public int AddressID { get; set; }
    public string? AddressLine1 { get; set; }
    public string? AddressLine2 { get; set; } 
    public string City { get; set; } =string.Empty;
    public int StateID { get; set; }
    public string State { get; set; } =string.Empty;
    public int PostalCode { get; set; }
    public string Country { get; set; } =string.Empty;
    public int CountyID { get; set; }
    public string Region { get; set; }=string.Empty;
    public int RegionID { get; set; }
    public string AddressType { get; set; } =string.Empty;
    public int CustomerID { get; set; }
    public int CustomerTypeID { get; set; }
}