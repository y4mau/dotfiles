---
name: requirements-generator-v5
description: use this agent to instruct to generate requirements
model: opus
color: blue
---

# Functional Requirements Document Generation Prompt Template

## Overview

This template is a prompt for generating a comprehensive set of requirement documents for full-stack feature implementation.

## Document Essence

### Architecture Principles
1. **Layer Separation**: Clear separation of data layer, business logic layer, and presentation layer
2. **Technology Stack-based Organization**: Managing backend, frontend, styling, and testing as independent documents
3. **Traceability with Functional Requirements**: Each design element is mapped to functional requirements
4. **Phased Implementation Plan**: MVP → Improvement → Extension phases

### Document Structure Pattern
- **00_overview.md**: Overall picture, functional requirements, technology stack, implementation priority
- **01_data_model.md**: Data model, DB design, data flow
- **02_backend.md**: Server-side implementation (API, services, batch)
- **03_frontend_[technology].md**: Frontend implementation (supporting multiple technology stacks)
- **04_logging.md**: Log design, tracking
- **05_styling.md**: UI/UX design, style implementation
- **06_testing.md**: Test strategy, test cases

---

## User Input Template

### Required Information

#### 1. Project Basic Information
```markdown
**Project Name**: [Feature name]
**Purpose**: [The problem this feature solves]
**Target Users**: [Expected user persona]
```

#### 2. Design Information
```markdown
**Design Tool**: [Figma/Sketch/Adobe XD, etc.]
**Design URL**: [Link to design file]
**Main Screen List**:
- Screen 1: [URL], Node ID: [ID], Description: [Overview]
- Screen 2: [URL], Node ID: [ID], Description: [Overview]
```

#### 3. Functional Requirements
```markdown
**Functional Requirements List**:
F1. [Feature name]
   - [Specific requirement 1]
   - [Specific requirement 2]

F2. [Feature name]
   - [Specific requirement 1]
   - [Specific requirement 2]

[Add as many as needed]
```

#### 4. Technology Stack
```markdown
**Backend**:
- Language: [Ruby/Python/Node.js, etc.]
- Framework: [Rails/Django/Express, etc.]
- Database: [PostgreSQL/MySQL/MongoDB, etc.]
- Data Source: [BigQuery/Redshift, etc.]
- Batch Processing: [Tool to use]

**Frontend**:
- Recommended Technology: [React/Vue/Angular, etc.]
- Alternative Technology: [Vanilla JS/existing framework]
- Language: [TypeScript/JavaScript]

**Infrastructure & Others**:
- Logging: [Logging service to use]
- Cache: [Redis/Memcached, etc.]
- CI/CD: [GitHub Actions/CircleCI, etc.]
```

#### 5. Data Source Details
```markdown
**Primary Data Source**:
- Source Name: [BigQuery table name, etc.]
- Access Method: [API/Direct query/Batch sync]
- Update Frequency: [Real-time/Daily/Weekly]
- Used Columns:
  - [Column name 1]: [Description]
  - [Column name 2]: [Description]
```

#### 6. Integration with Existing Systems
```markdown
**Integration Points**:
- [Existing feature 1]: [Integration method overview]
- [Existing API 1]: [Purpose of use]
- [Existing component 1]: [Reuse method]
```

#### 7. Logging & Analysis Requirements
```markdown
**Log Collection Events**:
- [Event 1]: [Timing, collected data]
- [Event 2]: [Timing, collected data]

**Analysis Purpose**:
- [KPI 1]: [Measurement method]
- [KPI 2]: [Measurement method]
```

#### 8. Implementation Priority
```markdown
**Phase 1 (MVP)**: [Target release date]
- [Feature 1]
- [Feature 2]

**Phase 2 (Improvement)**: [Target release date]
- [Feature 1]
- [Feature 2]

**Phase 3 (Extension)**: [Target release date]
- [Feature 1]
- [Feature 2]
```

### Optional Information

#### Performance Requirements
```markdown
- Page Load Time: [Target value]
- API Response Time: [Target value]
- Concurrent Connections: [Expected value]
```

#### Security Requirements
```markdown
- Authentication Method: [OAuth2/JWT, etc.]
- Permission Management: [Requirements]
- Data Encryption: [Requirements]
```

#### Accessibility Requirements
```markdown
- WCAG Compliance Level: [A/AA/AAA]
- Supported Screen Readers: [List]
- Keyboard Operation: [Requirements]
```

---

## Expected Output Document Structure

Generated documents should have the following structure:

### 1. 00_overview.md
- Project overview
- Figma design information
- Functional requirements overview (specify corresponding design documents for each requirement)
- Technology stack
- Implementation priority
- Related document links

### 2. 01_data_model.md
- Corresponding functional requirements
- Data flow overview (Mermaid diagram)
- Data source table definitions
- Application DB design
- ActiveRecord/ORM model definitions
- Data structure relationship diagram (Mermaid diagram)

### 3. 02_backend.md
- Corresponding functional requirements
- Batch implementation (if applicable)
- API implementation
- Service layer implementation
- ViewComponent/Template implementation
- Controller implementation
- i18n configuration

### 4. 03_frontend_[technology].md
- Corresponding functional requirements
- Architecture overview (Mermaid diagram)
- Component structure
- Type definitions
- Main component implementation
- Sub-component implementation
- Hooks/Utility implementation
- Webpack/Build configuration

### 5. 04_logging.md
- Corresponding functional requirements
- Log type list
- Schema definition for each log
- Log sending timing
- Log sending implementation examples
- Event value mapping

### 6. 05_styling.md
- Corresponding functional requirements
- UI components (detailed specifications from Figma)
- Design system (colors, typography, spacing)
- SCSS/CSS implementation
- Responsive design
- Animations
- Accessibility support

### 7. 06_testing.md
- Corresponding functional requirements
- Test strategy
- Test coverage goals
- Backend tests (Model, Service, Controller, Component)
- Frontend tests (React/Jest)
- Integration tests (System/E2E)
- Test data (Factories)
- CI/CD integration

---

## Generation Guidelines

### About Code Examples
- Provide complete, implementable code examples
- Minimize comments (strive for self-documenting code)
- Follow best practices
- Maintain consistency with existing project patterns
- **Wrap code blocks in collapsible sections for GitHub issues**: Use `<details>` tags to make code sections toggleable:
  ```markdown
  <details>
  <summary>Implementation code</summary>

  ```ruby
  # code here
  ```

  </details>
  ```

### About Diagrams
- Use Mermaid notation for flow diagrams and class diagrams
- Visualize complex architectures
- Always diagram data flows

### About Traceability
- Place "Corresponding Functional Requirements" section at the beginning of each design document
- Ensure bidirectional links from functional requirements to design elements

### About Implementation Priority
- Clearly identify features essential for MVP
- Present phased implementation plan
- Show approach to minimize technical debt

---

## Customization Guide

This template can be customized for the following purposes:

### For Microservice Architecture
- Add documentation for inter-service communication (gRPC/REST)
- Include service discovery and API Gateway design

### For Mobile Apps
- Separate implementation documents by platform (iOS/Android)
- Include offline support and push notification design

### For Real-time Features
- Add WebSocket/SSE design documentation
- Include concurrent connection and scaling strategy

### For Machine Learning Features
- Add documentation for model design, training data, inference pipeline
- Include model versioning and A/B testing design
