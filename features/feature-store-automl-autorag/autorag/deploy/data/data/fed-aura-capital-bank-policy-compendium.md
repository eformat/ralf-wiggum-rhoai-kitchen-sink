# Fed Aura Capital Bank -- Regulatory Policy Compendium

**Compendium Version:** 1.0
**Compilation Date:** 30 June 2025
**Classification:** Internal -- Restricted
**Compiled by:** Group Compliance Office
**Purpose:** Consolidated reference of all active regulatory policies for internal advisory and compliance use.

---

## Table of Contents

- Part I: DORA Implementation Policy (FACB-POL-DORA-2025-001 v2.3)
- Part II: MiFID II Product Governance Policy (FACB-POL-MIFID-PG-2024-003 v4.1)
- Part III: CSRD ESG Data Collection Playbook for Lending (FACB-PLB-CSRD-LEND-2025-001 v1.2)
- Part IV: Third-Party ICT Risk Management Framework (FACB-FRM-TPICT-2025-002 v3.0)
- Part V: Risk Appetite Statement (FACB-POL-RISK-2024-001 v5.0)
- Part VI: Anti-Money Laundering and Know Your Customer Policy (FACB-POL-AML-2025-001 v6.0)

---

# Part I: DORA Implementation Policy

**Document ID:** FACB-POL-DORA-2025-001
**Version:** 2.3
**Effective Date:** 17 January 2025
**Classification:** Internal -- Restricted
**Owner:** Group Chief Information Security Officer (CISO)
**Approved by:** Board Risk Committee, 12 December 2024
**Next Review:** 17 January 2026

---

## 1. Purpose and Scope

This policy establishes Fed Aura Capital Bank's ("the Bank") requirements for compliance with Regulation (EU) 2022/2554, the Digital Operational Resilience Act (DORA). It applies to all entities within the Fed Aura Capital Bank Group operating across the European Union, European Economic Area, and the United Kingdom where equivalence has been adopted.

DORA entered into application on 17 January 2025. This policy supersedes all prior ICT governance documents including FACB-POL-ICT-2023-004 and FACB-POL-OUTSOURCE-2024-002.

### 1.1 Entities in Scope

| Entity | Jurisdiction | Regulator | DORA Classification |
|--------|-------------|-----------|---------------------|
| Fed Aura Capital Bank AG | Germany | BaFin / ECB | Significant Credit Institution |
| Fed Aura Capital Bank S.A. | France | ACPR / ECB | Significant Credit Institution |
| Fed Aura Securities B.V. | Netherlands | AFM / DNB | Investment Firm |
| Fed Aura Asset Management Ltd | Ireland | CBI | Fund Manager (AIFM) |
| Fed Aura Payments GmbH | Germany | BaFin | Payment Institution |

---

## 2. Governance Framework

### 2.1 Management Body Responsibilities

The Management Board bears ultimate responsibility for the ICT risk management framework. In accordance with Article 5 of DORA, the Management Board shall:

a) Define, approve, oversee and be accountable for the implementation of the ICT risk management framework described in Section 3.
b) Set clear roles and responsibilities for all ICT-related functions, including the CISO, Chief Technology Officer (CTO), and Head of ICT Operations.
c) Allocate and periodically review the budget for ICT security, which for 2025 is set at EUR 47 million across the Group.
d) Approve and review the digital operational resilience strategy at least annually.
e) Ensure adequate training. All Management Board members shall complete the DORA awareness programme (minimum 8 hours annually) by 31 March each year.

### 2.2 Three Lines of Defence

- **First Line:** Business units and IT operations own and manage ICT risks daily.
- **Second Line:** The CISO Office and Group Risk Management provide oversight, set standards, and monitor compliance.
- **Third Line:** Group Internal Audit provides independent assurance on the ICT risk management framework.

### 2.3 Reporting

The CISO shall provide the Management Board with a quarterly ICT risk report covering: active incidents, threat landscape assessment, third-party ICT concentration risks, penetration testing results, and recovery capability metrics.

---

## 3. ICT Risk Management Framework

### 3.1 Identification

The Bank shall maintain a comprehensive and up-to-date inventory of:

a) All ICT assets, including hardware, software, network devices, and cloud resources. The current inventory contains 14,287 assets as of Q4 2024.
b) All information assets and their classification (Public, Internal, Confidential, Strictly Confidential).
c) All ICT-supported business functions and their criticality rating (Critical, Important, Standard).
d) All interconnections and dependencies between ICT systems, including data flows between entities.

### 3.2 Protection and Prevention

The Bank shall implement layered security controls including:

a) Network segmentation between production, development, and management zones.
b) Multi-factor authentication for all access to critical or important ICT systems.
c) Encryption of data at rest (AES-256) and in transit (TLS 1.2 minimum, TLS 1.3 preferred).
d) Patch management: critical patches within 72 hours, high within 14 days, medium within 30 days.
e) Privileged access management with just-in-time elevation and session recording.

### 3.3 Detection

Continuous monitoring through the Group Security Operations Centre (SOC), which operates 24/7/365. Detection capabilities include:

a) SIEM platform ingesting logs from all critical systems (minimum retention: 13 months).
b) Endpoint detection and response (EDR) on all workstations and servers.
c) Network traffic analysis with anomaly detection.
d) Dark web monitoring for credential exposure.

### 3.4 Response and Recovery

See Section 5 for incident management. Recovery Time Objectives (RTOs) and Recovery Point Objectives (RPOs) are defined per business function:

| Business Function | Criticality | RTO | RPO |
|-------------------|-------------|-----|-----|
| Core Banking Platform | Critical | 2 hours | 15 minutes |
| Payments Processing (SEPA, TARGET2) | Critical | 1 hour | 0 (synchronous replication) |
| Trading Platform | Critical | 4 hours | 1 hour |
| Customer Online Banking | Important | 8 hours | 1 hour |
| Internal Email and Collaboration | Standard | 24 hours | 4 hours |

---

## 4. Third-Party ICT Provider Management

### 4.1 Contractual Requirements

In accordance with Article 30 of DORA, all contracts with ICT third-party service providers supporting critical or important functions shall include the following provisions. Existing contracts must be remediated by 17 January 2026.

#### 4.1.1 Mandatory Contractual Clauses

a) **Service Level Descriptions:** Clear, quantitative descriptions of the functions to be provided, including performance targets, availability guarantees (minimum 99.95% for critical functions), and capacity commitments.

b) **Data Location:** Specification of the regions and countries where data will be processed and stored. For the Bank's EU operations, data must remain within the EEA unless a specific risk assessment and Board approval have been obtained.

c) **Audit Rights:** The Bank, its competent authorities (ECB, BaFin, ACPR, etc.), and resolution authorities shall have full audit and access rights, including:
   - On-site inspections with 10 business days' notice (5 business days in case of urgency)
   - Access to relevant documentation, systems, and personnel
   - The right to perform or commission independent audits at least annually
   - Pooled audit arrangements where permitted

d) **Sub-outsourcing:** The provider must notify the Bank at least 60 days before any material sub-outsourcing. The Bank retains the right to object and terminate if the sub-outsourcing materially changes the risk profile.

e) **Exit Strategy:** Each contract shall include a detailed exit plan covering:
   - Transition period: minimum 12 months for critical functions, 6 months for important functions
   - Data portability: the provider must return all data in a machine-readable, non-proprietary format
   - Knowledge transfer: the provider must support migration, including documentation and staff availability
   - Continued service provision during the transition period
   - Destruction of data after migration, with written certification

f) **Incident Notification:** The provider must notify the Bank of any ICT-related incident within 4 hours of detection. For incidents classified as major (see Section 5.2), immediate notification via the designated emergency channel is required.

g) **Business Continuity:** The provider must maintain and test business continuity and disaster recovery plans at least annually. Test results must be shared with the Bank within 30 days of testing.

### 4.2 Risk Assessment

Before onboarding any ICT third-party provider for critical or important functions, the Bank shall conduct a risk assessment covering:

a) Financial stability and viability of the provider
b) Information security posture (SOC 2 Type II or ISO 27001 certification required)
c) Geographical and political risks of data processing locations
d) Concentration risk (see Section 4.3)
e) Substitutability assessment: can the function be migrated to an alternative provider within the exit timeline?

### 4.3 Concentration Risk

The Bank shall maintain a register of all ICT third-party providers and assess concentration risk quarterly. Concentration risk exists when:

a) A single provider supports more than 3 critical business functions
b) A single provider accounts for more than 30% of the Bank's total ICT expenditure
c) Multiple critical functions depend on the same underlying sub-contractor or infrastructure (e.g., a single cloud region)

Current concentration risk assessment (Q1 2025):

| Provider | Critical Functions Supported | ICT Spend Share | Risk Level |
|----------|-----------------------------|--------------------|------------|
| AWS (eu-central-1) | Core Banking, Payments, Online Banking | 34% | High -- mitigation plan active |
| SAP SE | HR, Finance, Procurement | 12% | Medium |
| Bloomberg L.P. | Trading, Market Data | 8% | Low |

### 4.4 Oversight of Critical ICT Third-Party Service Providers

For providers designated as critical by the European Supervisory Authorities (ESAs), the Bank shall participate in the Lead Overseer's oversight framework and cooperate with information requests. The Bank currently has exposure to 2 designated critical ICT third-party providers.

---

## 5. ICT Incident Management

### 5.1 Classification

All ICT-related incidents shall be classified upon detection using the following criteria from DORA Article 18:

| Criterion | Major Incident Threshold |
|-----------|--------------------------|
| Clients affected | > 10,000 or > 10% of total clients |
| Duration | > 2 hours for critical functions |
| Data loss | Any loss of confidential or strictly confidential data |
| Geographic spread | > 2 Member States affected |
| Economic impact | > EUR 500,000 estimated direct/indirect cost |

### 5.2 Reporting to Competent Authorities

Major ICT-related incidents shall be reported to the competent authority as follows:

a) **Initial notification:** Within 4 hours of classification as major, and no later than 24 hours after detection.
b) **Intermediate report:** Within 72 hours of the initial notification, providing root cause analysis and impact assessment.
c) **Final report:** Within 1 month of the incident, providing full post-incident review, lessons learned, and remediation actions.

Reports shall be submitted via the standardised templates specified in the DORA Implementing Technical Standards (ITS) using the ECB's IMAS portal.

### 5.3 Significant Cyber Threats

The Bank shall also report significant cyber threats to the competent authority on a voluntary basis, where the threat could have a material impact on the Bank or the broader financial system.

---

## 6. Digital Operational Resilience Testing

### 6.1 Basic Testing

All ICT systems supporting critical or important functions shall be subject to at least the following annual tests:

a) Vulnerability scanning (quarterly, at minimum)
b) Open source software analysis
c) Network security assessments
d) Physical security reviews of data centres
e) Gap analysis against emerging threats
f) Source code reviews for internally developed critical applications
g) Scenario-based testing (including tabletop exercises)
h) Compatibility and performance testing

### 6.2 Threat-Led Penetration Testing (TLPT)

In accordance with Article 26 of DORA, the Bank shall conduct threat-led penetration testing at least every 3 years, and more frequently if required by the competent authority.

a) TLPT shall be conducted in accordance with the TIBER-EU framework.
b) Tests shall cover the Bank's live production systems, including systems operated by critical ICT third-party providers (with the provider's agreement and the competent authority's approval).
c) The scope shall be agreed with the ECB/BaFin in advance.
d) Testing teams shall be independent, certified, and have no conflicts of interest.
e) Results shall be reported to the Board Risk Committee within 30 days of completion.
f) Remediation of critical findings must commence within 5 business days of the final report.

### 6.3 Testing of ICT Third-Party Providers

Where TLPT includes systems of ICT third-party providers, the Bank shall:

a) Coordinate with the provider to define scope and rules of engagement
b) Ensure the provider grants necessary access for testing
c) Use pooled testing arrangements where multiple financial entities use the same provider
d) Share results with the competent authority as required

---

## 7. Information Sharing

The Bank participates in the following threat intelligence sharing arrangements in accordance with Article 45 of DORA:

a) EBF Cyber Threat Intelligence Sharing Group
b) FIRST (Forum of Incident Response and Security Teams)
c) National CERT partnerships in Germany (BSI), France (ANSSI), and the Netherlands (NCSC-NL)

All shared information must be anonymised and classified appropriately before exchange. The CISO Office shall maintain a log of all information sharing activities.

---

## 8. Compliance and Enforcement

### 8.1 Internal Compliance

Compliance with this policy is mandatory. Violations shall be reported to the CISO Office and may result in disciplinary action up to and including termination.

### 8.2 Regulatory Penalties

Under DORA, competent authorities may impose administrative penalties of up to EUR 10 million or 5% of annual turnover for non-compliance. Individual senior managers may face personal liability.

---

## Part I Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 15 March 2024 | CISO Office | Initial draft for Board review |
| 2.0 | 12 December 2024 | CISO Office | Board-approved version |
| 2.1 | 17 January 2025 | CISO Office | Minor corrections; effective date confirmed |
| 2.2 | 15 March 2025 | CISO Office | Updated concentration risk table; added TLPT schedule |
| 2.3 | 30 June 2025 | CISO Office | Updated asset inventory count; added Q1 2025 concentration data |

---
---

# Part II: MiFID II Product Governance Policy

**Document ID:** FACB-POL-MIFID-PG-2024-003
**Version:** 4.1
**Effective Date:** 1 July 2024
**Classification:** Internal -- Restricted
**Owner:** Group Head of Compliance
**Approved by:** Management Board, 18 June 2024
**Next Review:** 1 July 2025

---

## 1. Purpose

This policy establishes the product governance framework for Fed Aura Capital Bank Group ("the Bank") in accordance with Directive 2014/65/EU (MiFID II), Commission Delegated Directive (EU) 2017/593, and applicable national implementing legislation in Germany (WpHG), France (Code monetaire et financier), the Netherlands (Wft), and Ireland (S.I. No. 375/2017).

The policy applies to all investment products manufactured by or distributed through the Bank, including structured products, funds, bonds, equities, derivatives, portfolio management mandates, and crypto-asset services.

---

## 2. Target Market Definition

### 2.1 Manufacturer Obligations

When the Bank acts as product manufacturer, the relevant Product Committee shall define the target market for each product using the following six categories:

a) **Client type:** Retail, Professional, or Eligible Counterparty
b) **Knowledge and experience:** Basic, Informed, or Advanced
c) **Financial situation:** Specific income/net worth thresholds; ability to bear losses (up to 100% for high-risk products)
d) **Risk tolerance:** SRRI 1-7 scale alignment; maximum acceptable downside
e) **Investment objectives:** Capital preservation, income generation, growth, hedging, speculative
f) **Investment horizon:** Short-term (< 1 year), medium-term (1-5 years), long-term (> 5 years)

### 2.2 Negative Target Market

Every product must also define a negative target market -- the client segments for whom the product is NOT suitable, even if they formally meet the positive target market criteria. Common negative target market factors include:

- Clients who cannot afford to lose any capital (for products with capital-at-risk features)
- Clients seeking regular income (for accumulation-only products)
- Clients with no experience in complex financial instruments (for structured products, derivatives, or leveraged products)
- Clients with an investment horizon shorter than the product's recommended minimum holding period

### 2.3 Distribution Strategy

The Product Committee shall specify the appropriate distribution strategy:

| Distribution Channel | Suitability Assessment Required | Appropriateness Test Required |
|---------------------|---------------------------------|-------------------------------|
| Investment advice (face-to-face) | Yes | N/A (suitability covers this) |
| Investment advice (digital/robo) | Yes | N/A |
| Non-advised execution (complex products) | No | Yes |
| Execution-only (non-complex products) | No | No (but client must be informed) |

---

## 3. Product Approval Process

### 3.1 New Product Committee

All new products or material modifications to existing products must be approved by the relevant Product Committee before launch. The Product Committee composition shall include:

- Product Manager (Chair)
- Compliance Officer (mandatory; has veto right)
- Risk Manager
- Legal Counsel
- Sales/Distribution representative
- Operations representative

### 3.2 Approval Criteria

The Product Committee shall assess:

a) Does the product meet a genuine client need?
b) Is the product's risk/return profile appropriate for the intended target market?
c) Are all costs, charges, and fees transparent and reasonable?
d) Is the product consistent with the Bank's risk appetite (see Part V: Risk Appetite Statement)?
e) Does the product comply with all applicable regulations, including ESG disclosure requirements under SFDR?
f) Has stress testing been performed across at least 3 adverse scenarios?

### 3.3 Product Review Cycle

All products shall be reviewed at least annually, or more frequently if:

- Market conditions change materially
- A significant number of client complaints are received (> 5 per quarter)
- Regulatory changes affect the product
- Performance deviates significantly from the expected range

---

## 4. Crypto-Asset Services

### 4.1 Regulatory Framework

Since the application of Regulation (EU) 2023/1114 (MiCA) on 30 December 2024, the Bank's crypto-asset services are subject to both MiFID II (where the crypto-asset qualifies as a financial instrument) and MiCA (for all other crypto-assets).

### 4.2 Crypto Custody Service

The Bank offers crypto custody services through its subsidiary Fed Aura Digital Assets GmbH, which holds a BaFin crypto custody license (Kryptoverwahrgeschaeft) under Section 1(1a) sentence 2 no. 6 KWG.

#### 4.2.1 Eligible Clients

Crypto custody services are available to:

a) **Professional clients:** Subject to standard onboarding and appropriateness assessment
b) **Retail clients:** Subject to enhanced suitability assessment including:
   - Demonstrated understanding of blockchain technology and crypto-asset risks (minimum score of 70% on the Bank's Crypto Knowledge Assessment)
   - Maximum allocation: 10% of investable assets (unless the client provides a written waiver after receiving the enhanced risk disclosure)
   - Cooling-off period: 48 hours between completing the suitability assessment and executing the first crypto-asset transaction

#### 4.2.2 Supported Assets

The Bank currently supports custody of the following crypto-assets:

| Asset | Classification | Custody Solution | Insurance Coverage |
|-------|---------------|------------------|--------------------|
| Bitcoin (BTC) | Crypto-asset (MiCA) | Cold storage (multi-sig) | EUR 100M aggregate |
| Ethereum (ETH) | Crypto-asset (MiCA) | Cold storage (multi-sig) | EUR 100M aggregate |
| USDC | E-money token (MiCA) | Cold storage | EUR 50M aggregate |
| Tokenised Bonds | Financial instrument (MiFID II) | DLT Settlement System | Standard investor protection |

#### 4.2.3 Jurisdictional Restrictions

| Jurisdiction | Retail Crypto Custody | Professional Crypto Custody | Notes |
|-------------|----------------------|----------------------------|-------|
| Germany (BaFin) | Permitted (with enhanced suitability) | Permitted | Home jurisdiction of the license |
| France (ACPR/AMF) | Permitted (with PSAN/DASP registration) | Permitted | DASP registration obtained March 2025 |
| Netherlands (AFM) | Restricted -- under review | Permitted | Awaiting AFM guidance on MiCA transitional measures |
| Ireland (CBI) | Not currently offered | Permitted | Retail offering planned for Q3 2025 |
| United Kingdom | Not offered | Not offered | FCA regime separate from MiCA; evaluation in progress |

#### 4.2.4 Risk Disclosures

Before opening a crypto custody account, the client must acknowledge receipt and understanding of:

a) The "Key Risks of Crypto-Asset Investment" document (FACB-DISC-CRYPTO-2025-001)
b) The specific risk that crypto-assets are not covered by deposit guarantee schemes
c) The risk of total loss of investment
d) Volatility risks: historical maximum drawdown data for each supported asset
e) Technology risks: smart contract vulnerabilities, protocol changes, hard forks
f) Regulatory risks: potential changes in the legal treatment of crypto-assets

---

## 5. Cost and Charges Transparency

### 5.1 Ex-Ante Disclosure

Before any transaction, clients must receive a clear breakdown of all costs, expressed both as a percentage and as a monetary amount, including:

a) Service costs (advisory fees, custody fees, platform fees)
b) Product costs (management fees, performance fees, transaction costs within the product)
c) Entry and exit charges
d) Incidental costs (performance fees, carried interest)
e) Cumulative effect on return over the recommended holding period

### 5.2 Ex-Post Reporting

Annually, by 30 April, all clients shall receive a personalised cost report showing:

a) Total costs paid during the preceding calendar year
b) Itemised breakdown by cost category
c) Impact of costs on the portfolio's return
d) Comparison with the ex-ante estimate provided at the point of sale

---

## 6. Inducements

### 6.1 General Prohibition

The Bank does not accept or pay inducements in connection with investment advice on an independent basis or portfolio management, except for minor non-monetary benefits that meet the quality enhancement test.

### 6.2 Non-Independent Advice

Where the Bank provides non-independent investment advice, any inducements received must:

a) Enhance the quality of the service to the client
b) Not impair the firm's duty to act in the client's best interest
c) Be clearly disclosed to the client, including the amount or calculation method

### 6.3 Research

Following MiFID II unbundling requirements, the Bank pays for third-party investment research from its own resources (Research Payment Account). Research costs are not passed on to clients.

---

## 7. Suitability and Appropriateness

### 7.1 Suitability Assessment

When providing investment advice or portfolio management, the Bank shall assess:

a) The client's knowledge and experience in the relevant product type
b) The client's financial situation, including ability to bear losses
c) The client's investment objectives, including risk tolerance and sustainability preferences (under the MiFID II ESG amendments effective August 2022)

Suitability assessments must be refreshed:
- At least annually for portfolio management clients
- Before each new transaction for advisory clients (unless the client profile is less than 12 months old and circumstances have not materially changed)

### 7.2 Appropriateness Assessment

For non-advised services involving complex products, the Bank shall assess whether the client has the necessary knowledge and experience to understand the risks. If the product is assessed as not appropriate, the Bank shall warn the client and document the warning and the client's response.

---

## 8. Record-Keeping

All records relating to product governance, suitability assessments, appropriateness tests, and cost disclosures shall be retained for a minimum of 5 years (10 years for pension-related products), in accordance with Article 72 of the MiFID II Delegated Regulation.

---

## Part II Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 3.0 | 1 January 2023 | Compliance | Annual refresh |
| 4.0 | 1 January 2024 | Compliance | Added crypto-asset services; MiCA integration |
| 4.1 | 1 July 2024 | Compliance | Updated jurisdictional table for crypto; DASP registration |

---
---

# Part III: CSRD ESG Data Collection Playbook for Lending

**Document ID:** FACB-PLB-CSRD-LEND-2025-001
**Version:** 1.2
**Effective Date:** 1 January 2025
**Classification:** Internal -- Restricted
**Owner:** Group Head of Sustainability
**Approved by:** Group Risk Committee, 14 November 2024
**Next Review:** 1 July 2025

---

## 1. Purpose

This playbook provides operational guidance for credit analysts, relationship managers, and sustainability officers on the ESG data that must be collected from loan applicants under the Corporate Sustainability Reporting Directive (Directive (EU) 2022/2464, "CSRD") and the EU Taxonomy Regulation (Regulation (EU) 2020/852).

The Bank is required to disclose the Green Asset Ratio (GAR) and Banking Book Taxonomy Alignment Ratio (BTAR) in its annual sustainability report from FY2025 onwards. Accurate data collection from borrowers is essential for these disclosures.

---

## 2. Scope of Application

### 2.1 Which Borrowers Must Provide ESG Data?

| Borrower Type | CSRD Reporting Obligation | Bank's ESG Data Requirement |
|---------------|---------------------------|------------------------------|
| Large EU companies (> 250 employees, > EUR 50M revenue, > EUR 25M assets -- meeting 2 of 3) | Yes, from FY2025 | Mandatory -- full ESRS data package |
| Listed SMEs (on EU regulated markets) | Yes, from FY2027 (opt-out until FY2028) | Mandatory from FY2027; voluntary early adoption encouraged |
| Non-listed SMEs | No CSRD obligation | Simplified ESG questionnaire (VSME standard) |
| Non-EU companies with EUR 150M+ EU revenue | Yes, from FY2029 | Mandatory from FY2029; early engagement recommended |
| Sovereign and public sector | Not applicable | Excluded from GAR/BTAR calculations |

### 2.2 Transitional Period

During the transitional period (2025-2028), where borrowers are not yet subject to CSRD reporting, the Bank shall:

a) Use the simplified VSME questionnaire (see Annex A)
b) Accept estimates and proxies where verified data is not yet available
c) Document all data sources and estimation methodologies
d) Engage proactively with borrowers to build data collection capabilities

---

## 3. ESG Data Requirements by Loan Type

### 3.1 General Purpose Corporate Loans

Collect the following at origination and annually at review:

#### Environmental Data (E)

a) **Scope 1 GHG emissions:** Direct emissions from owned or controlled sources (tonnes CO2e)
b) **Scope 2 GHG emissions:** Indirect emissions from purchased electricity, heat, steam (tonnes CO2e), reported using both location-based and market-based methods
c) **Scope 3 GHG emissions:** Material upstream and downstream emissions (at minimum: purchased goods and services, business travel, employee commuting, use of sold products). Required for companies with > 500 employees; encouraged for others.
d) **EU Taxonomy eligibility:** Percentage of revenue, CapEx, and OpEx from Taxonomy-eligible economic activities
e) **EU Taxonomy alignment:** Percentage of revenue, CapEx, and OpEx from Taxonomy-aligned economic activities (meeting substantial contribution, DNSH, and minimum safeguards criteria)
f) **Transition plan:** Does the borrower have a Paris-aligned transition plan? If yes, key targets and milestones.
g) **Energy consumption:** Total energy consumption in MWh; share of renewable energy
h) **Water usage:** Total water withdrawal in cubic metres (for water-intensive sectors: agriculture, mining, textiles, food & beverage)

#### Social Data (S)

a) **Workforce composition:** Total headcount; breakdown by gender, contract type (permanent/temporary), and region
b) **Gender pay gap:** Mean and median gender pay gap percentage
c) **Health and safety:** Lost Time Injury Frequency Rate (LTIFR); fatalities
d) **Living wage:** Does the borrower ensure adequate wages (as defined by ESRS S1)?
e) **Human rights due diligence:** Does the borrower have a human rights due diligence process covering its value chain?
f) **Collective bargaining:** Percentage of workforce covered by collective bargaining agreements

#### Governance Data (G)

a) **Board composition:** Number of board members; percentage independent; gender diversity
b) **ESG governance:** Is there a board-level committee with ESG oversight responsibility?
c) **Anti-corruption:** Does the borrower have an anti-corruption and anti-bribery policy?
d) **Whistleblowing:** Is there a whistleblowing mechanism accessible to employees and external stakeholders?
e) **Tax transparency:** Does the borrower publish a country-by-country tax report?

### 3.2 Commercial Real Estate Loans

In addition to the general requirements above, collect:

a) **Energy Performance Certificate (EPC) rating** for each property in the portfolio
b) **Primary energy demand** in kWh/m2/year
c) **CO2 emissions intensity** in kgCO2/m2/year
d) **Nearly Zero-Energy Building (NZEB) compliance:** Does the building meet the NZEB standard as defined in the EPBD recast?
e) **Renovation plans:** Are there planned or in-progress deep energy renovations?
f) **Taxonomy alignment for buildings:** Does the building meet the technical screening criteria under EU Taxonomy Climate Delegated Act (Commission Delegated Regulation (EU) 2021/2139)?
   - For new buildings: primary energy demand at least 10% below NZEB threshold
   - For existing buildings: EPC class A, or within top 15% of national building stock by primary energy demand
   - For renovations: achieving at least 30% improvement in primary energy demand

### 3.3 Project Finance and Infrastructure Loans

In addition to general requirements:

a) **Environmental Impact Assessment (EIA):** Has an EIA been completed? Summary of findings.
b) **Equator Principles category:** A (high risk), B (medium risk), or C (low risk)
c) **Taxonomy-specific technical screening criteria** for the relevant economic activity (e.g., electricity generation must be below 100g CO2e/kWh)
d) **Biodiversity impact:** Is the project located in or near a protected area (Natura 2000, Key Biodiversity Area)?
e) **Circular economy considerations:** Waste management plan; recycled content targets

### 3.4 SME Loans (Simplified Requirements)

For non-listed SMEs not subject to CSRD, use the Voluntary SME Sustainability Reporting Standard (VSME). Collect at minimum:

a) **Sector classification:** NACE code of primary business activity
b) **GHG emissions:** Scope 1 and 2 (estimates acceptable using sector-average emission factors if primary data is unavailable)
c) **Energy source:** Primary energy source (grid electricity, natural gas, renewable)
d) **Employee count and basic workforce data**
e) **Environmental certifications:** ISO 14001, EMAS, or equivalent
f) **Climate risk exposure:** Self-assessment of physical and transition risk exposure (using the Bank's simplified questionnaire in Annex B)

---

## 4. EU Taxonomy Technical Screening Criteria -- Key Sectors

### 4.1 Lending to the Energy Sector

| Activity | Substantial Contribution Criterion | DNSH Criteria |
|----------|-----------------------------------|---------------|
| Electricity generation (solar PV) | Life-cycle emissions < 100g CO2e/kWh | Water, circular economy, pollution, biodiversity assessments |
| Electricity generation (wind) | Life-cycle emissions < 100g CO2e/kWh | Biodiversity assessment; end-of-life plan for turbine blades |
| Electricity generation (natural gas) | Life-cycle emissions < 270g CO2e/kWh (transitional, until 2030); direct emissions < 550kg CO2e/kW | Must replace a more carbon-intensive plant; transition plan required |
| District heating/cooling | Emissions below applicable benchmarks | Pollution prevention; use of sustainable heat sources |

### 4.2 Lending to the Transport Sector

| Activity | Substantial Contribution Criterion | DNSH Criteria |
|----------|-----------------------------------|---------------|
| Passenger cars | Zero direct CO2 emissions (BEV/FCEV) | Battery recycling plan; compliance with Euro 6 for pollutants |
| Freight transport (road) | Zero direct CO2 emissions or specific CO2 thresholds for heavy-duty vehicles | Noise; tyre particle emissions |
| Rail transport | Zero direct tailpipe emissions or < 50g CO2/pkm (passenger) | Noise mitigation |
| Shipping | Zero direct CO2 or IMO 2030 target compliance | Ballast water management; anti-fouling |

### 4.3 Lending to the Building Sector

See Section 3.2 above for specific criteria applicable to commercial real estate loans.

### 4.4 Lending to the Manufacturing Sector

| Activity | Substantial Contribution Criterion | DNSH Criteria |
|----------|-----------------------------------|---------------|
| Steel (basic iron and steel) | Emissions < 1.331 tCO2e/t of steel | Air pollution (BAT); water; waste |
| Cement | Emissions < 0.469 tCO2e/t of cement | Air pollution; waste; water |
| Aluminium | Emissions < 1.514 tCO2e/t of aluminium | Fluoride emissions; spent potliner management |

---

## 5. Data Quality and Assurance

### 5.1 Data Quality Tiers

| Tier | Description | Acceptable Use |
|------|-------------|----------------|
| Tier 1 -- Verified | Data from borrower's CSRD report, with limited or reasonable assurance from an auditor | All disclosures; preferred for GAR calculation |
| Tier 2 -- Reported | Data self-reported by the borrower but not yet independently assured | Acceptable during transitional period; document limitations |
| Tier 3 -- Estimated | Data estimated using sector averages, proxies, or models | SMEs only; must document methodology; flag as estimated in disclosures |
| Tier 4 -- Unavailable | Borrower unable or unwilling to provide data | Record engagement attempts; use conservative assumptions (assume non-aligned) |

### 5.2 Engagement Protocol

Where data is Tier 3 or Tier 4, the relationship manager shall:

a) Send the standardised ESG data request letter (template in Annex C) within 30 days of loan origination or annual review
b) Offer the borrower access to the Bank's ESG data collection portal
c) Provide sector-specific guidance on how to measure and report the required data points
d) Escalate to the Head of Sustainability if no response is received within 60 days
e) Document all engagement attempts in the credit file

---

## 6. Integration into Credit Process

### 6.1 At Origination

a) Relationship Manager collects ESG data using the relevant questionnaire (Annex A, B, or full ESRS data package)
b) Credit Analyst integrates ESG data into the credit memorandum, including:
   - Borrower's EU Taxonomy alignment percentage
   - Material ESG risks identified
   - Transition risk assessment (exposure to carbon pricing, stranded assets, regulatory changes)
   - Physical risk assessment (exposure to floods, droughts, heat waves, sea level rise)
c) Credit Committee considers ESG factors alongside traditional credit metrics

### 6.2 Pricing Impact

Taxonomy-aligned loans may qualify for preferential pricing under the Bank's Green Lending Framework:

| Taxonomy Alignment | Interest Rate Adjustment |
|--------------------|--------------------------|
| > 90% aligned revenue | -15 bps |
| 50-90% aligned revenue | -10 bps |
| < 50% aligned revenue | Standard pricing |
| Borrower with credible transition plan + SLLs | -5 to -10 bps (case by case) |

### 6.3 At Annual Review

a) ESG data must be refreshed at each annual credit review
b) Compare year-on-year trends in key ESG metrics
c) Assess progress against any sustainability-linked targets in the loan documentation
d) Update the Taxonomy alignment classification

---

## 7. Reporting and Disclosure

### 7.1 Internal Reporting

The Sustainability team shall provide quarterly reports to the Group Risk Committee covering:

a) Portfolio-level Taxonomy alignment (GAR and BTAR)
b) Data coverage rates by borrower segment
c) Sector-level ESG risk heatmap
d) Engagement progress with Tier 3/4 borrowers

### 7.2 External Disclosure

In the Bank's annual sustainability report (first report for FY2025, published Q1 2026):

a) Green Asset Ratio (GAR): proportion of Taxonomy-aligned assets in the banking book
b) Banking Book Taxonomy Alignment Ratio (BTAR): including voluntary reporting for non-CSRD counterparties
c) Financed emissions (PCAF methodology, Scope 3 Category 15)
d) Data quality disclosure: breakdown of data by quality tier

---

## Annexes

- **Annex A:** Full ESRS Data Collection Questionnaire (for CSRD-reporting counterparties)
- **Annex B:** Simplified ESG Questionnaire for SMEs (based on VSME standard)
- **Annex C:** Standardised ESG Data Request Letter Template
- **Annex D:** Sector-Specific Emission Factor Tables (for Tier 3 estimation)

---

## Part III Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 14 November 2024 | Sustainability Team | Initial version |
| 1.1 | 1 January 2025 | Sustainability Team | Updated Taxonomy criteria per Climate Delegated Act amendments |
| 1.2 | 1 April 2025 | Sustainability Team | Added SME engagement protocol; updated pricing table |

---
---

# Part IV: Third-Party ICT Risk Management Framework

**Document ID:** FACB-FRM-TPICT-2025-002
**Version:** 3.0
**Effective Date:** 17 January 2025
**Classification:** Internal -- Restricted
**Owner:** Group Chief Information Security Officer (CISO)
**Co-Owner:** Group Head of Procurement
**Approved by:** Board Risk Committee, 12 December 2024
**Next Review:** 17 January 2026

---

## 1. Purpose

This framework governs the lifecycle management of all third-party ICT service providers engaged by Fed Aura Capital Bank Group ("the Bank"). It implements the requirements of DORA Chapter V (Articles 28-44) and aligns with EBA Guidelines on ICT and Security Risk Management (EBA/GL/2019/04) and the ECB's Supervisory Expectations on ICT Risk.

This framework supplements the DORA Implementation Policy (Part I of this compendium) and should be read in conjunction with it.

---

## 2. Provider Classification

### 2.1 Criticality Assessment

All ICT third-party providers shall be classified based on the criticality of the functions they support:

| Classification | Criteria | Governance Level | Review Frequency |
|---------------|----------|------------------|------------------|
| Critical | Supports a critical business function as defined in the Bank's BIA; failure would have systemic impact or severe operational disruption | Board Risk Committee oversight; dedicated relationship manager | Quarterly |
| Important | Supports an important business function; failure would cause significant but manageable disruption | CTO/CISO oversight; annual performance review | Semi-annually |
| Standard | Supports standard business functions; alternatives are readily available | Procurement management | Annually |

### 2.2 Current Provider Register

The Bank maintains relationships with 247 ICT third-party providers as of Q1 2025. Classification breakdown:

| Classification | Number of Providers | Annual Spend (EUR M) |
|---------------|--------------------|-----------------------|
| Critical | 12 | 89.3 |
| Important | 38 | 34.7 |
| Standard | 197 | 21.4 |

---

## 3. Onboarding Process

### 3.1 Pre-Engagement Due Diligence

Before engaging any new ICT third-party provider for critical or important functions, the following assessments shall be completed:

#### 3.1.1 Security Assessment

a) Review of the provider's information security certifications:
   - **Mandatory for Critical:** SOC 2 Type II + ISO 27001 certification
   - **Mandatory for Important:** SOC 2 Type II or ISO 27001
   - **Standard:** Self-assessment questionnaire (SAQ) based on the Bank's ICT security checklist

b) Independent vulnerability assessment of the provider's internet-facing infrastructure
c) Review of the provider's incident history (last 3 years)
d) Assessment of the provider's security governance structure

#### 3.1.2 Financial Viability Assessment

a) Review of the provider's audited financial statements (last 3 years)
b) Credit risk assessment using the Bank's internal rating methodology
c) Assessment of the provider's client concentration (is the Bank a significant client?)
d) Evaluation of the provider's insurance coverage

#### 3.1.3 Geopolitical and Legal Assessment

a) Jurisdictional analysis: where is the provider incorporated, and where will data be processed?
b) Data protection impact assessment (DPIA) where required under GDPR Article 35
c) Assessment of government access to data risks (particularly for non-EEA providers)
d) Sanctions screening (EU, US OFAC, UK sanctions lists)

#### 3.1.4 Concentration Risk Assessment

a) Does the provider already support other critical functions for the Bank?
b) Do multiple critical functions depend on the same underlying infrastructure?
c) Is the provider designated as a Critical ICT Third-Party Service Provider by the ESAs?
d) What is the Bank's ability to substitute this provider within the contractual exit timeline?

### 3.2 Approval Authority

| Provider Classification | Approval Required |
|------------------------|-------------------|
| Critical | Board Risk Committee |
| Important | CTO + CISO joint approval |
| Standard | Procurement Committee |

---

## 4. Contractual Requirements

### 4.1 Mandatory Contract Clauses

See Part I: DORA Implementation Policy, Section 4.1 for the complete list of mandatory contractual clauses required by Article 30 of DORA.

### 4.2 Contract Remediation Programme

As of 17 January 2025, 73% of existing contracts with critical and important ICT third-party providers have been remediated to include all DORA-required clauses. The remediation programme targets are:

| Milestone | Target Date | Status |
|-----------|-------------|--------|
| Critical provider contracts remediated | 30 June 2025 | 92% complete |
| Important provider contracts remediated | 31 December 2025 | 68% complete |
| Standard provider contracts remediated | 30 June 2026 | 41% complete |

### 4.3 Sub-Outsourcing Chain Management

The Bank shall maintain visibility of the entire sub-outsourcing chain for critical and important functions:

a) The provider must disclose all sub-contractors involved in the delivery of the service
b) Material changes to the sub-outsourcing chain require 60 days' prior notification
c) The Bank reserves the right to object to any new sub-contractor within 30 days of notification
d) Sub-contractors must meet the same security and data protection standards as the primary provider
e) The Bank maintains a sub-outsourcing register with 142 sub-contractors mapped across critical providers

---

## 5. Ongoing Monitoring

### 5.1 Performance Monitoring

| Metric | Critical Providers | Important Providers | Standard Providers |
|--------|-------------------|--------------------|--------------------|
| Service availability | Real-time monitoring; 99.95% target | Monthly reporting; 99.9% target | Quarterly reporting; 99.5% target |
| Incident response time | 15-minute acknowledgment; 4-hour resolution for P1 | 1-hour acknowledgment; 8-hour resolution for P1 | Next business day |
| Patch management | Critical patches within 72 hours | Critical patches within 7 days | Critical patches within 30 days |
| SLA compliance | Monthly review with provider | Quarterly review | Annual review |

### 5.2 Security Monitoring

a) **Annual security reassessment:** Updated SOC 2 Type II report or ISO 27001 surveillance audit results
b) **Continuous monitoring:** The Bank subscribes to threat intelligence feeds that monitor the security posture of key providers (BitSight, SecurityScorecard)
c) **Penetration testing:** Critical providers must permit annual penetration testing of interfaces used by the Bank
d) **Incident reporting:** All providers must report security incidents within the timeframes specified in the contract (4 hours for critical providers)

### 5.3 Financial Health Monitoring

a) Annual review of audited financial statements
b) Continuous monitoring via credit rating agency alerts
c) Quarterly review of news and market intelligence for signs of financial distress
d) Escalation triggers: credit rating downgrade, significant litigation, management changes, M&A activity

---

## 6. Exit Management

### 6.1 Exit Planning

Every critical and important ICT third-party provider engagement shall have a documented exit plan that is:

a) Created during the onboarding process (before contract signing)
b) Reviewed and updated at least annually
c) Tested at least every 2 years for critical providers (through tabletop exercises or partial dry runs)

### 6.2 Exit Plan Contents

Each exit plan shall include:

a) **Alternative providers:** At least 2 identified alternative providers, with preliminary commercial terms
b) **Migration timeline:** Realistic timeline for full migration, including:
   - Data extraction and validation: 4-8 weeks
   - Parallel running period: 8-12 weeks for critical functions
   - Full cutover and decommissioning: 2-4 weeks
c) **Resource requirements:** Internal and external staffing, budget, and infrastructure needs
d) **Data handling:** Procedures for data extraction, validation, migration, and certified destruction
e) **Communication plan:** Internal and external stakeholder communication during transition
f) **Risk mitigation:** Identified risks and mitigating controls for the transition period

### 6.3 Exit Triggers

An exit from an ICT third-party provider may be triggered by:

a) Material and repeated SLA breaches (3 or more P1 incidents in a quarter)
b) Security breach affecting the Bank's data
c) Financial distress or insolvency of the provider
d) Regulatory action against the provider
e) Concentration risk exceeding thresholds (see Part I, Section 4.3)
f) Strategic decision to in-source the function
g) Provider acquisition by a competitor or sanctioned entity

---

## 7. Register and Reporting

### 7.1 Information Register

In accordance with Article 28(3) of DORA, the Bank shall maintain a Register of Information on all contractual arrangements with ICT third-party providers. This register is maintained in the GRC platform and includes:

a) Provider identification (name, LEI, jurisdiction)
b) Functions provided and their criticality classification
c) Contract details (start date, end date, renewal terms)
d) Data processing locations
e) Sub-outsourcing chain
f) Exit plan reference
g) Competent authority notifications

The register shall be made available to the ECB, BaFin, and other competent authorities upon request.

### 7.2 Regulatory Reporting

a) The Information Register shall be updated within 5 business days of any material change
b) Annual submission to the competent authority as required by DORA implementing standards
c) Ad hoc reporting in the event of major incidents involving ICT third-party providers

---

## 8. Roles and Responsibilities

| Role | Responsibility |
|------|---------------|
| Board Risk Committee | Approve critical provider engagements; oversee concentration risk |
| CISO | Security assessment; ongoing security monitoring; incident coordination |
| CTO | Technical assessment; performance monitoring; architecture review |
| Head of Procurement | Contract management; commercial terms; vendor relationship |
| Business Function Owner | Define requirements; accept residual risk; manage day-to-day relationship |
| DPO | GDPR compliance; DPIA oversight; international transfer assessments |
| Internal Audit | Independent assurance on the framework's effectiveness (annual audit) |

---

## Part IV Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 1 March 2023 | CISO Office | Initial framework |
| 2.0 | 15 September 2024 | CISO Office | DORA alignment; Board-approved |
| 3.0 | 17 January 2025 | CISO Office | Effective with DORA application; updated provider register data |

---
---

# Part V: Risk Appetite Statement

**Document ID:** FACB-POL-RISK-2024-001
**Version:** 5.0
**Effective Date:** 1 January 2025
**Classification:** Internal -- Confidential
**Owner:** Group Chief Risk Officer (CRO)
**Approved by:** Board of Directors, 19 December 2024
**Next Review:** December 2025

---

## 1. Introduction

This Risk Appetite Statement ("RAS") defines the aggregate level and types of risk that Fed Aura Capital Bank Group ("the Bank") is willing to assume within its risk capacity to achieve its strategic objectives. It is approved by the Board of Directors annually and cascaded to all business units and subsidiaries.

The RAS is consistent with the Bank's:
- Strategic Plan 2024-2027 ("Resilient Growth")
- Recovery Plan (submitted to ECB, version 7.0)
- Internal Capital Adequacy Assessment Process (ICAAP)
- Internal Liquidity Adequacy Assessment Process (ILAAP)

---

## 2. Risk Appetite Metrics and Thresholds

### 2.1 Capital Adequacy

| Metric | Minimum Threshold | Target | Limit (Escalation) |
|--------|-------------------|--------|---------------------|
| CET1 Ratio | 10.5% (regulatory minimum incl. buffers) | 13.0% | < 12.0% triggers Board escalation |
| Total Capital Ratio | 14.0% (regulatory minimum) | 17.0% | < 15.5% triggers Board escalation |
| Leverage Ratio | 3.0% (regulatory minimum) | 4.5% | < 4.0% triggers Board escalation |
| MREL Ratio | Per SRB determination | MREL + 2% buffer | < MREL + 1% triggers escalation |

### 2.2 Liquidity

| Metric | Minimum Threshold | Target | Limit |
|--------|-------------------|--------|-------|
| Liquidity Coverage Ratio (LCR) | 100% (regulatory minimum) | 130% | < 115% triggers escalation |
| Net Stable Funding Ratio (NSFR) | 100% (regulatory minimum) | 110% | < 105% triggers escalation |
| Survival period (stress) | 30 days (regulatory) | 90 days | < 60 days triggers escalation |

### 2.3 Credit Risk

| Metric | Appetite |
|--------|----------|
| Single-name concentration | No single counterparty exposure > 5% of Tier 1 capital (regulatory large exposure limit: 25%) |
| Sector concentration | No single NACE sector > 15% of total loan book |
| Geographic concentration | No single non-home-market country > 10% of total loan book |
| Non-performing loan (NPL) ratio | Target < 2.5%; escalation at > 3.5% |
| Expected credit loss (ECL) coverage ratio | Stage 3 coverage > 50% |
| Probability of default (PD) portfolio average | < 1.5% for investment-grade target |

### 2.4 Market Risk

| Metric | Appetite |
|--------|----------|
| Value at Risk (99%, 1-day) | < EUR 25 million |
| Stressed VaR | < EUR 50 million |
| Interest rate risk in banking book (IRRBB) | EVE sensitivity to +200bps: < EUR 300 million |
| Foreign exchange open position | < EUR 100 million aggregate |

### 2.5 Operational Risk

| Metric | Appetite |
|--------|----------|
| Operational risk losses (annual) | < EUR 30 million aggregate |
| Single operational loss event | < EUR 10 million (events > EUR 5M trigger Board notification) |
| Cyber incidents (major) | Zero tolerance for data breaches; target < 2 major incidents per year |
| System availability (core banking) | > 99.95% |
| Third-party ICT concentration risk | No single provider > 30% of ICT spend (see Part I, Section 4.3) |

### 2.6 Compliance and Conduct Risk

| Metric | Appetite |
|--------|----------|
| Regulatory sanctions and fines | Zero tolerance |
| AML/CFT suspicious activity reports | N/A (volume is an output, not a target) |
| Client complaints (MiFID products) | < 0.5% of active client accounts per quarter |
| Conduct risk events | Zero tolerance for market manipulation, insider dealing, or client detriment |
| GDPR data breaches (reportable) | Target: zero; escalation at > 2 per year |

---

## 3. Strategic Risk Boundaries

### 3.1 New Business Activities

The Bank is willing to enter new business activities provided they:

a) Are consistent with the Bank's licensed activities and regulatory permissions
b) Generate a risk-adjusted return on capital (RAROC) > 12%
c) Do not create unacceptable concentration risk
d) Can be adequately risk-managed with existing or obtainable capabilities
e) Have been approved by the relevant governance body (see Section 5)

### 3.2 Crypto-Asset Activities

The Bank's risk appetite for crypto-asset activities is **moderate and controlled:**

a) Crypto custody services: Permitted, through a licensed subsidiary (see Part II: MiFID II Product Governance Policy, Section 4.2)
b) Proprietary trading in crypto-assets: Not permitted
c) Crypto lending: Not permitted
d) Crypto-asset exposure on balance sheet: Maximum EUR 50 million (< 0.1% of total assets)
e) DeFi protocol exposure: Not permitted
f) Stablecoin reserves management: Permitted for regulated e-money tokens only

### 3.3 ESG and Climate Risk

a) New financing for thermal coal mining or coal-fired power generation: Not permitted (phase-out by 2030)
b) Oil and gas sector: Permitted with enhanced due diligence; transition plan required from borrowers
c) Taxonomy-aligned lending target: > 30% of new origination by 2027
d) Financed emissions reduction target: -40% by 2030 (vs. 2020 baseline, using PCAF methodology)
e) Physical risk: Maximum portfolio exposure to high physical risk zones: 8% of total loan book

### 3.4 Geographic Expansion

a) Core markets: Germany, France, Netherlands, Ireland -- full product offering
b) Growth markets: Spain, Italy, Poland -- selective product offering; subject to local regulatory approval
c) Non-EU markets: UK (existing operations only; no expansion pending Brexit clarity); Switzerland (wealth management only)
d) Sanctioned or high-risk jurisdictions: No new business; existing exposures to be wound down per the Sanctions Compliance Policy

---

## 4. Risk Culture

### 4.1 Principles

a) Risk management is everyone's responsibility, not just the Risk function
b) Open and transparent risk reporting is expected; there shall be no penalty for raising risk concerns
c) Risk-taking within appetite is encouraged; risk-taking outside appetite requires explicit Board approval
d) Compensation structures must not incentivise excessive risk-taking (in accordance with CRD V remuneration requirements)

### 4.2 Risk Appetite Breaches

| Severity | Definition | Escalation |
|----------|-----------|------------|
| Level 1 (Watch) | Metric approaching the limit but within threshold | Head of Risk for the business unit |
| Level 2 (Breach) | Metric has breached the limit | CRO and Management Board within 24 hours |
| Level 3 (Critical) | Metric has breached the minimum threshold or a zero-tolerance metric has been triggered | Board of Directors within 4 hours; regulator notification if required |

---

## 5. Governance

### 5.1 Approval Hierarchy for Risk Decisions

| Decision | Approval Authority |
|----------|-------------------|
| Annual Risk Appetite Statement | Board of Directors |
| New product or business line (RAROC > 12%) | Management Board + Board Risk Committee |
| Single counterparty exposure > 2% of Tier 1 capital | Board Risk Committee |
| Exception to risk appetite limit (temporary) | CRO + CEO jointly; Board notification within 5 business days |
| ICT third-party provider (critical) | Board Risk Committee (see Part I) |
| Entry into new geographic market | Board of Directors |

---

## Part V Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 4.0 | 20 December 2023 | CRO Office | Annual refresh for FY2024 |
| 5.0 | 19 December 2024 | CRO Office | Annual refresh for FY2025; updated crypto appetite; added DORA references; updated ESG targets |

---
---

# Part VI: Anti-Money Laundering and Know Your Customer Policy

**Document ID:** FACB-POL-AML-2025-001
**Version:** 6.0
**Effective Date:** 1 January 2025
**Classification:** Internal -- Strictly Confidential
**Owner:** Group Money Laundering Reporting Officer (MLRO)
**Approved by:** Board of Directors, 19 December 2024
**Next Review:** 1 July 2025

---

## 1. Purpose and Legal Basis

This policy establishes the Anti-Money Laundering (AML), Counter-Terrorist Financing (CTF), and Know Your Customer (KYC) framework for Fed Aura Capital Bank Group ("the Bank"). It implements the requirements of:

- Directive (EU) 2024/1640 (6th Anti-Money Laundering Directive, "AMLD6")
- Regulation (EU) 2024/1624 (Single AML Rulebook, "AMLR")
- Regulation (EU) 2024/1620 establishing the Anti-Money Laundering Authority ("AMLA Regulation")
- German Money Laundering Act (GwG)
- French Monetary and Financial Code (Code monetaire et financier, Articles L.561-1 et seq.)
- Applicable national legislation in the Netherlands and Ireland

The establishment of AMLA in Frankfurt am Main, with direct supervision commencing 1 July 2025, will require the Bank to coordinate with AMLA as the lead supervisor for cross-border AML/CFT matters.

---

## 2. Customer Due Diligence (CDD)

### 2.1 Standard CDD Requirements

For all new customers and at trigger events, the Bank shall:

a) **Identify the customer** and verify identity using reliable, independent sources:
   - Natural persons: government-issued photo ID (passport, national ID card, residence permit); verification via electronic identity verification (eIDV) or in-person document inspection
   - Legal entities: commercial register extract, articles of association, certificate of incorporation; LEI verification mandatory for entities that are required to have one

b) **Identify and verify the beneficial owner(s):**
   - Any natural person who ultimately owns or controls > 25% of the shares, voting rights, or ownership interest (noting that AMLD6 has lowered this to 25% from any higher national thresholds)
   - Where no natural person is identified under the ownership/control test, the senior managing official(s) shall be identified
   - For listed companies on EU regulated markets, the requirement may be satisfied by disclosure of the shareholder register and management board

c) **Understand the purpose and intended nature of the business relationship:**
   - Expected transaction types and volumes
   - Source of funds (origin of the money used in the relationship)
   - Source of wealth (origin of the customer's total assets and net worth)
   - Expected countries of transaction activity

d) **Conduct ongoing monitoring** of the business relationship (see Section 4)

### 2.2 Enhanced Due Diligence (EDD)

EDD shall be applied in the following higher-risk situations:

| Risk Factor | EDD Measure |
|------------|-------------|
| Politically Exposed Person (PEP) -- domestic, foreign, or international organisation | Senior management approval for onboarding; enhanced source of wealth verification; ongoing enhanced monitoring |
| High-risk third country (as per EU AML lists and FATF grey/black lists) | Senior management approval; enhanced source of funds verification; enhanced transaction monitoring |
| Complex or unusual ownership structures | Full beneficial ownership chain to natural person(s); explanation of commercial rationale for the structure |
| Private banking / high net worth (> EUR 1 million) | Enhanced source of wealth documentation; face-to-face or video KYC; annual review |
| Correspondent banking | Wolfsberg questionnaire; assessment of respondent bank's AML/CFT controls; senior management approval |
| Crypto-asset customers (retail and professional) | Enhanced source of funds for deposits > EUR 10,000; blockchain analytics for incoming crypto transactions; Travel Rule compliance |
| Non-face-to-face onboarding | Electronic identity verification with liveness detection; additional independent identity verification source |

### 2.3 Simplified Due Diligence (SDD)

SDD may be applied only where the risk assessment demonstrates a lower risk of ML/TF. Eligible categories include:

a) EU/EEA governments and public bodies
b) EU-regulated financial institutions
c) Listed companies on EU regulated markets (subject to transparency requirements)
d) Low-value products meeting specific criteria (e.g., electronic money with maximum stored value of EUR 150 where the card is non-reloadable)

Note: SDD is never appropriate for PEP relationships, high-risk countries, or where there is any suspicion of ML/TF.

---

## 3. Risk Assessment

### 3.1 Enterprise-Wide Risk Assessment (EWRA)

The Bank conducts an annual EWRA to identify, assess, and understand the ML/TF risks it faces. The EWRA considers:

a) **Customer risk:** Customer types, industries, geographies, and ownership structures
b) **Product and service risk:** Complexity, opacity, and ML/TF vulnerability of each product
c) **Channel risk:** Face-to-face vs. remote onboarding; digital banking channels
d) **Geographic risk:** Countries of operation, transaction counterparties
e) **Emerging risks:** New typologies identified by FIUs, FATF, and law enforcement

### 3.2 Customer Risk Scoring

Each customer is assigned an AML risk score at onboarding and updated at each review. The scoring model considers:

| Factor | Weight | Risk Levels |
|--------|--------|-------------|
| Customer type (natural person, legal entity, trust) | 15% | Low / Medium / High |
| Country of residence/incorporation | 20% | Low / Medium / High / Prohibited |
| Country of business activity | 15% | Low / Medium / High / Prohibited |
| Industry/sector | 15% | Low / Medium / High |
| Product type | 15% | Low / Medium / High |
| PEP status | 10% | Non-PEP / PEP (escalation factor) |
| Source of funds and wealth | 10% | Verified / Partially verified / Unverified |

Overall risk rating: **Low** (score 1-30), **Medium** (31-60), **High** (61-80), **Very High** (81-100)

### 3.3 Review Frequency

| Risk Rating | Review Frequency |
|-------------|------------------|
| Low | Every 3 years |
| Medium | Every 2 years |
| High | Annually |
| Very High | Every 6 months |
| PEP | Annually (minimum) |

---

## 4. Transaction Monitoring

### 4.1 Automated Monitoring

The Bank operates an automated transaction monitoring system covering all accounts and transaction types. The system applies rule-based and behavioural analytics to detect:

a) Transactions inconsistent with the customer's known profile
b) Structuring (splitting transactions to avoid reporting thresholds)
c) Rapid movement of funds (layering)
d) Transactions involving high-risk countries
e) Cash transactions above EUR 10,000 (for cash-handling branches)
f) Crypto-asset transactions above EUR 1,000 (Travel Rule threshold)
g) Unusual patterns: dormant account activation, round-amount transfers, circular transactions

### 4.2 Alert Handling

| Alert Priority | SLA for Investigation | Investigator Level |
|---------------|----------------------|-------------------|
| Priority 1 (Critical) | 4 hours | Senior AML Investigator |
| Priority 2 (High) | 24 hours | AML Investigator Level 2 |
| Priority 3 (Medium) | 5 business days | AML Investigator Level 1 |
| Priority 4 (Low / auto-close eligible) | 10 business days | Analyst / automated resolution |

### 4.3 Suspicious Activity Reporting (SAR)

Where an investigation concludes that there are reasonable grounds to suspect money laundering or terrorist financing:

a) The MLRO (or designated deputy) shall submit a SAR to the relevant Financial Intelligence Unit (FIU):
   - Germany: Financial Intelligence Unit (FIU Deutschland) via goAML
   - France: TRACFIN via ERMES portal
   - Netherlands: FIU-Nederland via goAML-NL
   - Ireland: Financial Intelligence Unit Ireland via goAML

b) SARs must be filed "as soon as practicable" and no later than 3 business days after the MLRO's decision to report
c) The customer must NOT be tipped off about the SAR (tipping off is a criminal offence)
d) All SAR-related documentation must be retained for at least 5 years from the date of the report

### 4.4 Travel Rule Compliance

For crypto-asset transfers, the Bank shall comply with the Travel Rule (Regulation (EU) 2023/1113):

a) For all crypto-asset transfers, regardless of amount: originator and beneficiary information must be transmitted
b) Before executing a transfer > EUR 1,000: verify the originator's identity against CDD records
c) Incoming transfers missing required information: hold and request missing data within 2 business days; if not received within 5 business days, reject the transfer
d) Use the TRUST protocol or compatible messaging layer for Travel Rule compliance

---

## 5. Sanctions Screening

### 5.1 Screening Requirements

All customers, beneficial owners, directors, connected parties, and transaction counterparties shall be screened against:

a) EU Consolidated Financial Sanctions List
b) OFAC Specially Designated Nationals (SDN) List
c) UK HM Treasury Sanctions List
d) UN Security Council Consolidated List
e) National sanctions lists of jurisdictions where the Bank operates

### 5.2 Screening Frequency

| Screening Type | Frequency |
|---------------|-----------|
| Customer onboarding | Real-time (before account opening) |
| Ongoing customer screening | Daily batch screening against updated lists |
| Transaction screening | Real-time for all outgoing SWIFT/SEPA payments |
| Crypto-asset screening | Real-time address screening using blockchain analytics |

### 5.3 Match Handling

| Match Type | Action | SLA |
|-----------|--------|-----|
| True positive -- SDN/EU sanctions hit | Freeze account/transaction; notify competent authority within 24 hours | Immediate |
| True positive -- sectoral sanctions | Apply restrictions per sanctions programme; legal review | 4 hours |
| Potential match -- requires investigation | Hold transaction; investigate within 2 business hours | 2 hours |
| False positive | Document rationale; clear alert; update screening system | 4 hours |

---

## 6. Record-Keeping

a) CDD documentation: retained for at least 5 years after the end of the business relationship
b) Transaction records: retained for at least 5 years from the date of the transaction
c) SAR-related documents: retained for at least 5 years from the date of the SAR filing
d) Training records: retained for the duration of employment plus 3 years
e) All records must be retrievable within 5 business days if requested by competent authorities

---

## 7. Training

| Audience | Training Requirement | Frequency |
|----------|---------------------|-----------|
| All employees | General AML/CFT awareness | Annually (online module, 1 hour) |
| Client-facing staff | AML/CFT specific to their role; red flag recognition | Annually (2 hours) |
| AML/CFT team | Advanced typologies; investigation techniques; regulatory updates | Quarterly (4 hours) |
| Management Board | Strategic AML/CFT risks; regulatory developments; SAR statistics | Semi-annually (1 hour) |
| MLRO and deputies | Continuing professional development; FIU engagement; regulatory dialogues | Ongoing |

---

## 8. Governance

| Role | Responsibility |
|------|---------------|
| Board of Directors | Approve AML/CFT policy; receive annual EWRA and MLRO report |
| Management Board | Allocate resources; ensure implementation; appoint MLRO |
| MLRO | Day-to-day AML/CFT leadership; SAR decisions; regulatory liaison |
| AML/CFT Department | KYC, transaction monitoring, sanctions screening, investigations |
| First Line (Business) | Collect CDD; identify suspicious activity; escalate to AML team |
| Internal Audit | Independent assurance on AML/CFT framework effectiveness |
| Data Protection Officer | GDPR compliance in AML/CFT processing; DPIA oversight |

---

## Part VI Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 5.0 | 1 January 2024 | MLRO Office | Annual update; AMLD5 alignment |
| 6.0 | 1 January 2025 | MLRO Office | AMLD6 and AMLR alignment; AMLA references; crypto Travel Rule update; updated CDD thresholds |
