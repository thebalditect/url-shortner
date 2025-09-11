# 2. Use REST over GRPC

Date: 2025-09-11

Author: Mandar Dharmadhikari

## Status

Accepted

## Context
We need to expose a public API for the URL shortener service. Two primary choices are:  

1. **REST over HTTP with JSON** (implemented via FastAPI)  
2. **gRPC with Protocol Buffers**  

Both are widely used approaches, but they serve slightly different purposes. REST/JSON is the de facto standard for public APIs, while gRPC excels in microservice-to-microservice communication.  

Key considerations include:  
- **Target audience**: Our clients include browsers, mobile apps, and potential third-party integrators. These consumers expect JSON/HTTP APIs.  
- **Ease of adoption**: JSON + REST is universally understood. gRPC requires code generation and specific client libraries.  
- **Tooling**: REST APIs automatically integrate with Swagger/OpenAPI for docs and testing. gRPC lacks widely adopted interactive documentation tools.  
- **Performance**: gRPC is more efficient for high-throughput internal services, but performance is not currently a bottleneck for this system.  

## Decision
We will use **REST over HTTP with JSON** as the API style, implemented with **FastAPI**.  

- REST endpoints provide predictable, resource-oriented URLs.  
- JSON serialization is human-readable, easy to debug, and widely supported.  
- FastAPI automatically generates OpenAPI documentation, improving developer experience.  
- We explicitly defer gRPC until there is a demonstrated need for service-to-service high-performance communication.  

## Consequences

**Positive**
- Lower learning curve for contributors and consumers.  
- Built-in, auto-generated Swagger UI for documentation.  
- Simple integration with browsers, cURL, Postman, and mobile apps.  
- Faster time-to-market.  

**Negative**
- Slightly larger payloads than Protobuf.  
- Less efficient for high-volume internal traffic.  
- Not as strongly typed as gRPC contracts.    

## References
- [FastAPI](https://fastapi.tiangolo.com/)  
- [gRPC](https://grpc.io/)  
- [Conventional wisdom: REST for external APIs, gRPC for internal microservices](https://cloud.google.com/apis/design)  
