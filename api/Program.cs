using api.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

// Register IDatabaseService → SQLDatabaseService
// Controllers ask for IDatabaseService; ASP.NET Core hands them a SQLDatabaseService.
builder.Services.AddScoped<IDatabaseService, SQLDatabaseService>();

builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

var allowedOrigins = 
    builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? 
    Array.Empty<string>();

app.UseCors(policy =>
    policy.WithOrigins(allowedOrigins)
          .AllowAnyHeader()
          .AllowAnyMethod());

          
app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();