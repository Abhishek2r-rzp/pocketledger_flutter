# PocketLedger

Offline-first personal finance tracker for iPhone, built with Flutter and an agentic architecture that automatically categorizes, deduplicates, and enriches transactions.

![Dashboard](dashboard-chromium-darwin.png)

## Quick Links

- [Features](Features)
- [Architecture](Architecture)
- [Setup Guide](Setup)
- [Screenshots](Screenshots)

## Overview

PocketLedger is a local-first finance tracking app that never sends your data to the cloud. It uses a system of lightweight AI agents running entirely on-device to:

- **Parse** bank statements (CSV & PDF)
- **Categorize** transactions automatically
- **Deduplicate** repeated entries
- **Detect** recurring payments
- **Track** budgets and spending patterns
- **Manage** credit cards, accounts, and labels
- **Generate** insights and visualizations

All data stays on your device via local SQLite storage (drift).

## Tech Stack

- **Framework:** Flutter 3.x
- **State Management:** Riverpod 3.x
- **Database:** drift (SQLite)
- **Parsing:** CSV, PDF, XLSX
- **Charts:** fl_chart
- **Architecture:** Agentic (multi-agent system)
