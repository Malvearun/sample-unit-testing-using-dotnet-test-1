using Microsoft.AspNetCore.Mvc;
using Prime.Services; // Add this if it's missing

namespace PrimeApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PrimeController : ControllerBase
    {
        private readonly PrimeService _primeService;

        public PrimeController()
        {
            _primeService = new PrimeService();
        }

        [HttpGet("{number}")]
        public IActionResult IsPrime(int number)
        {
            var result = _primeService.IsPrime(number);
            return Ok(new { Number = number, IsPrime = result });
        }
    }
}