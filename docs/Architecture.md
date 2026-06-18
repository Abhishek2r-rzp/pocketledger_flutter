# Architecture

## Agentic Architecture

PocketLedger uses a multi-agent system inspired by AI agent workflows. Each agent is a focused, single-responsibility module that operates on local data:

```
┌────────────────────────────────────────────┐
│            Agent Orchestrator              │
├────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ Categor- │  │ Dedup-   │  │ Merchant │  │
│  │ ization  │  │ lication │  │ Cleaner  │  │
│  │  Agent   │  │  Agent   │  │  Agent   │  │
│  └──────────┘  └──────────┘  └──────────┘  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │Recurring │  │  Budget  │  │ Insight  │  │
│  │ Payment  │  │  Agent   │  │  Agent   │  │
│  │  Agent   │  │          │  │          │  │
│  └──────────┘  └──────────┘  └──────────┘  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ Learning │  │  Review  │  │ Privacy  │  │
│  │  Agent   │  │  Queue   │  │  Guard   │  │
│  │          │  │  Agent   │  │  Agent   │  │
│  └──────────┘  └──────────┘  └──────────┘  │
│  ┌──────────┐  ┌──────────┐                │
│  │Statement │  │Transaction│                │
│  │ Parser   │  │Normalizer│                │
│  │  Agent   │  │  Agent   │                │
│  └──────────┘  └──────────┘                │
└────────────────────────────────────────────┘
```

### Agents
| Agent | Responsibility |
|-------|---------------|
| **StatementParserAgent** | Parses CSV/PDF bank statements into raw transactions |
| **TransactionNormalizerAgent** | Standardizes amounts, dates, descriptions |
| **CategorizationAgent** | Auto-tags transactions with merchant & category |
| **MerchantCleanerAgent** | Normalizes merchant names (UPI-SWIGGY → Swiggy) |
| **DeduplicationAgent** | Detects and merges duplicate transactions |
| **RecurringPaymentAgent** | Identifies recurring payments (weekly, monthly) |
| **BudgetAgent** | Tracks spending vs budget limits |
| **LearningAgent** | Learns user corrections to improve future categorization |
| **ReviewQueueAgent** | Flags suspicious or uncategorized transactions |
| **InsightAgent** | Generates spending insights and patterns |
| **PrivacyGuardAgent** | Masks sensitive data in agent action logs |

## Data Layer

```
┌────────────────────────────────────────────┐
│              UI Layer (Screens)            │
├────────────────────────────────────────────┤
│          Riverpod Providers                │
├────────────────────────────────────────────┤
│           Repository (Abstract)            │
├────────────────────────────────────────────┤
│   DataRepository    │  DatabaseRepository  │
│   (In-Memory/Tests) │    (Drift/SQLite)    │
├────────────────────────────────────────────┤
│              Drift Database                │
├────────────────────────────────────────────┤
│               SQLite Storage               │
└────────────────────────────────────────────┘
```

The `Repository` abstract class unifies two implementations:
- **DataRepository** — In-memory store used for testing
- **DatabaseRepository** — Drift-backed SQLite store used in production

## State Management

Riverpod 3.x with:
- `StateNotifier` (legacy) for form/providers
- `StateProvider` for simple state
- `Provider` for derived data
- `FutureProvider` for async operations

## Project Structure

```
lib/
├── agents/           # Agent implementations
├── core/
│   ├── database/     # Drift schema + DAOs
│   ├── models/       # Domain models
│   ├── security/     # Biometrics, passcode
│   ├── theme/        # Dark theme, glass cards, animations
│   └── repository.dart / data_repository.dart / database_repository.dart
├── features/         # Feature modules (dashboard, transactions, etc.)
├── helpers/          # Constants, extensions
├── parsers/          # CSV, PDF, XLSX parsers
├── services/         # Search, export
└── router.dart       # GoRouter routes
```
