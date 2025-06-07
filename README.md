# Tokenized Printing Digital Rights Management (DRM) System

A comprehensive blockchain-based Digital Rights Management system built with Clarity smart contracts for the Stacks blockchain. This system manages digital content licensing, printing authorization, royalty distribution, and piracy prevention.

## 🚀 Features

### Core Contracts

1. **Publisher Verification Contract** (`publisher-verification.clar`)
    - Verifies and manages publishing companies
    - Maintains publisher registry with status tracking
    - Enables publisher verification and revocation

2. **Content Licensing Contract** (`content-licensing.clar`)
    - Registers digital content with metadata
    - Manages licensing terms and royalty rates
    - Tracks content ownership and status

3. **Print Authorization Contract** (`print-authorization.clar`)
    - Authorizes content printing with limits
    - Tracks print usage and expiration
    - Logs all printing activities

4. **Royalty Distribution Contract** (`royalty-distribution.clar`)
    - Manages author and publisher royalty payments
    - Calculates and distributes revenue shares
    - Tracks payment history and balances

5. **Piracy Prevention Contract** (`piracy-prevention.clar`)
    - Monitors printing activities for suspicious behavior
    - Flags accounts with violations
    - Manages violation reports and enforcement

## 🏗️ Architecture

\`\`\`
┌─────────────────────┐    ┌─────────────────────┐
│  Publisher          │    │  Content            │
│  Verification       │◄───┤  Licensing          │
└─────────────────────┘    └─────────────────────┘
│
▼
┌─────────────────────┐    ┌─────────────────────┐
│  Piracy             │    │  Print              │
│  Prevention         │◄───┤  Authorization      │
└─────────────────────┘    └─────────────────────┘
│
▼
┌─────────────────────┐
│  Royalty            │
│  Distribution       │
└─────────────────────┘
\`\`\`

## 🛠️ Installation

1. **Clone the repository**
   \`\`\`bash
   git clone <repository-url>
   cd tokenized-drm
   \`\`\`

2. **Install dependencies**
   \`\`\`bash
   npm install
   \`\`\`

3. **Run tests**
   \`\`\`bash
   npm test
   \`\`\`

## 📋 Usage

### Publisher Registration

1. Deploy the publisher verification contract
2. Call \`verify-publisher\` with publisher details
3. Publisher can now register content

### Content Registration

\`\`\`clarity
(contract-call? .content-licensing register-content
"Book Title"
"Author Name"
"standard"
u1000) ;; 10% royalty rate
\`\`\`

### Print Authorization

\`\`\`clarity
(contract-call? .print-authorization authorize-printing
u1          ;; content-id
'ST2CY...   ;; printer address
u100        ;; print limit
u1000       ;; duration in blocks
u50000)     ;; payment amount
\`\`\`

### Execute Printing

\`\`\`clarity
(contract-call? .print-authorization execute-print
u1    ;; content-id
u10)  ;; number of copies
\`\`\`

## 🔒 Security Features

- **Publisher Verification**: Only verified publishers can register content
- **Print Limits**: Enforced printing quotas and expiration dates
- **Activity Monitoring**: Automatic detection of suspicious printing patterns
- **Account Flagging**: Automated flagging of violators
- **Royalty Protection**: Secure royalty calculation and distribution

## 🧪 Testing

The system includes comprehensive test suites for all contracts:

- Publisher verification tests
- Content licensing tests
- Print authorization tests
- Royalty distribution tests
- Piracy prevention tests

Run tests with:
\`\`\`bash
npm test
\`\`\`

## 📊 Error Codes

| Contract | Error Code | Description |
|----------|------------|-------------|
| Publisher | ERR_UNAUTHORIZED (100) | Unauthorized access |
| Publisher | ERR_ALREADY_VERIFIED (101) | Publisher already verified |
| Publisher | ERR_NOT_VERIFIED (102) | Publisher not verified |
| Content | ERR_CONTENT_EXISTS (201) | Content already exists |
| Content | ERR_CONTENT_NOT_FOUND (202) | Content not found |
| Print | ERR_PRINT_LIMIT_EXCEEDED (304) | Print limit exceeded |
| Royalty | ERR_INSUFFICIENT_BALANCE (401) | Insufficient balance |
| Piracy | ERR_SUSPICIOUS_ACTIVITY (501) | Suspicious activity detected |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 Links

- [Stacks Documentation](https://docs.stacks.co/)
- [Clarity Language Reference](https://docs.stacks.co/clarity/)
- [Smart Contract Best Practices](https://docs.stacks.co/clarity/security/)
  \`\`\`

