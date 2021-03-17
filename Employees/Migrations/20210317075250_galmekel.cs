using Microsoft.EntityFrameworkCore.Migrations;

namespace Employees.Migrations
{
    public partial class galmekel : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Employees",
                columns: new[] { "Id", "Email", "Name", "PhotoPath", "Role" },
                values: new object[] { 4, "gal@gmail.com", "Gal Mekel", null, 0 });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Employees",
                keyColumn: "Id",
                keyValue: 4);
        }
    }
}
