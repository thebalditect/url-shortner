# ADR Management Script

A simple bash script to create and manage Architecture Decision Records (ADRs) in your repository with automatic numbering and consistent formatting.

## Installation

1. Copy the `create-adr.sh` script to your repository root
2. Make it executable:
   ```bash
   chmod +x create-adr.sh
   ```

## Usage

```bash
./create-adr.sh "ADR Title" "Author Name"
```

### Parameters

- **ADR Title** (required): The title of your architecture decision record
- **Author Name** (required): Name of the person creating the ADR

### Examples

```bash
# Create an ADR about database selection
./create-adr.sh "Use PostgreSQL for data persistence" "John Doe"

# Create an ADR about API design
./create-adr.sh "Adopt REST API over GraphQL" "Jane Smith"

# Create an ADR with special characters (automatically formatted)
./create-adr.sh "Use Docker & Kubernetes for Deployment" "Alex Johnson"
```

## What the Script Does

1. **Automatic Numbering**: Scans existing ADRs and assigns the next sequential number (0001, 0002, etc.)
2. **Title Formatting**: Converts titles to lowercase, hyphen-separated format for filenames
3. **File Creation**: Creates ADR files in `docs/adrs/` directory
4. **Template Population**: Uses a standard ADR template with metadata

## File Structure

The script creates files following this pattern:
```
docs/
└── adrs/
    ├── 0001-use-postgresql-for-data-persistence.md
    ├── 0002-adopt-rest-api-over-graphql.md
    └── 0003-use-docker-kubernetes-for-deployment.md
```

## Generated ADR Template

Each ADR is created with this structure:

```markdown
# 1. Use PostgreSQL for data persistence

Date: 2025-09-11
Author: John Doe

## Status

Proposed

## Context

<!-- Describe the context and problem statement -->

## Decision

<!-- Describe the architectural decision -->

## Consequences

<!-- Describe the resulting context and consequences -->
```

## Configuration

You can customize the script by modifying these variables at the top:

- `ADR_DIR`: Change the directory where ADRs are stored (default: `docs/adrs`)
- `ADR_TEMPLATE`: Modify the template structure and content

## Error Handling

The script includes validation for:
- Missing or empty parameters
- Duplicate ADR files
- Directory creation issues

## Tips

- The script will offer to open the newly created ADR in your default editor if the `EDITOR` environment variable is set
- Use descriptive titles that clearly indicate the architectural decision
- Review and update the Status section as decisions progress from "Proposed" to "Accepted" or "Rejected"