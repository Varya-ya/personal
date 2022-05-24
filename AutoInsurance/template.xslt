<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="path"/>
	<xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
				doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" indent="no"/>
	<xsl:decimal-format name="decimal" decimal-separator="." grouping-separator="," NaN="0" />
	<xsl:template match="/WCApplication">
		<!-- selected coverages -->
		<xsl:variable name="hiredAutoCoverageSelected" select="BusinessAuto/HiredBorrowedLiability = 'True'" />
		<xsl:variable name="nonOwnedAutoCoverageSelected" select="BusinessAuto/NonOwnedLiability = 'True'" />
		<xsl:variable name="otherEndorsementsSelected"
					select="Business[BusinessAutoEnhancementEndorsement = 'True' or AudioVisual = 'True']" />
		<!-- limits and premiums -->
		<xsl:variable name="liabilityLimit" select="BusinessAuto/LiabilityLimitsCSLAmount" />
		<xsl:variable name="UMLimit" select="BusinessAuto/UninsuredMotoristsLimitsCSLAmount" />
		<xsl:variable name="UIMLimit" select="BusinessAuto/UnderinsuredMotoristsLimitsCSLAmount" />
		<xsl:variable name="hiredAutoPremium" select="Proposal/Rating/PolicyLevelPremiumTable/HiredAuto" />
		<xsl:variable name="nonOwnedAutoPremium" select="Proposal/Rating/PolicyLevelPremiumTable/NonOwnedLiability" />
		<!-- misc variables -->
		<xsl:variable name="insuredName" select="General/InsuredName" />
		<xsl:variable name="vehiclesCollection" select="Vehicle/VehicleDescriptionRows/*" />
		<xsl:variable name="nonOwnedClassCode" select="Proposal/Rating/NonOwnedLiabilityClassCode" />

		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>EU Complete</title>
				<style type="text/css">
					body { font: 11pt Arial; text-align: left; }

					#std_centration { margin-left: auto; margin-right: auto; min-width: 814px; }

					.std_page { clear: both !important; margin: 0 auto; min-height: 1018px; padding-top: 10px; position: relative; width: 765px; page-break-after: always; }

					.hr { border-top: 10px solid #8FAADC; margin-top: 40px; width: 100%; }

					.left_menu     { background-color: #002060; height: 100%; left: -25px; padding-left: 20px; position: absolute; top: 0; width: 20%; }
					.left_menu div { color: white; font-weight: bold; position: relative; top: 50%; transform: translateY(-50%); }

					.right_panel       { min-height: 100%; padding-top: 10px; width: 75%; }
					.right_panel ul li { padding-bottom: 5px; }

					h1 { font: bold 14pt/1 Arial; margin: 0; }
					h2 { font: bold 12pt/1 Arial; margin-bottom: 5px; }
					h3 { font: bold 14pt/1 'Times New Roman'; text-align: center; }
					h4 { font: bold 11pt/1 Arial; margin-bottom: 3px; }

					ul { margin-left: 35px;	}

					.header_block  { overflow: hidden; padding-bottom: 10px; }
					.title         { font: bold 15.5pt Arial; text-align: center; }
					.top_image     { margin-bottom: 50px; }
					.top_image img { max-width: 100%; }

					table    { border-collapse: collapse; font-size: 10pt; margin-bottom: 0px; width: 100%; }
					table th { font-weight: normal; padding-bottom: 0px; text-align: left; }
					table td { padding-right: 0px; }

					.left  { float: left; }
					.right { float: right; }

					.left_padding { padding-left: 15px; }

					.txt_center { text-align: center; }
					.txt_right  { text-align: right !important; }
					.txt_underl { text-decoration: underline; }

					.red  { color: red; }
					.blue { color: #2f5496; }

					.fCalibri { font: 12pt Calibri; }
					.fTimes   { font: 12pt "Times New Roman", serif; }
					.fTimes p { margin-bottom: 30px; }

					.falls_lake { margin-bottom: 30px; margin-top: -10px; }

					.border_box { border: 1px solid #000; margin-bottom: 10px; overflow: hidden; padding: 3px; line-height: 14pt; clear: both; }

					.border__top     { border-top: 1px solid #000; clear: both; margin-bottom: 20px; }
					.border__top_    { border-top: 1px solid #000; }
					.border__bottom  { border-bottom: 1px solid #000; float: right; text-align: right; clear: both; margin-bottom: 3px; }
					.border__bottom_ { border-bottom: 1px solid #000; }

					.w50  { width: 50px; }
					.w100 { width: 100px; }
					.w150 { width: 150px; }
					.w200 { width: 200px; }
					.w250 { width: 250px; }
					.w350 { width: 350px; }
					.w450 { width: 450px; }

					.policywide_s_t-box { border: 1px solid #000; padding: 10px 15px; margin-bottom: 15px; }

					.optional_coverage-table       { margin-top: 15px; margin-bottom: 15px;}
					.optional_coverage-table thead { text-decoration: underline; margin-bottom: 15px; }

					.policy_information-table    { font-weight: bold; margin-bottom: 0; width: auto; }
					.policy_information-table td { padding-right: 30px; }
					.policy_information-table td:nth-child(even) { font-weight: normal; text-align: right; }

					.location_falls_lake-box   { border: 1px solid #000; margin-bottom: 20px; padding: 0 3px; }
					.location_falls_lake-table { margin-bottom: 0px; vertical-align: top; }
					.location_falls_lake-table .border__top { margin-bottom: 0; }

					.business_auto-box   { border: 1px solid #000; overflow: hidden; padding: 0 0 0 10px; }
					.business_auto-table { width: 300px; margin-bottom: 0; }

					.left .business_auto-table td:nth-child(2) { font-weight: bold; }

					.business_auto-blsec { margin-top: 10px; }

					.checkbox {
					display: inline-block;
					width: 11px;
					height: 11px;
					background: #ffffff;
					border: 1px solid #CCCCCC;
					margin-left: 10px;
					margin-right: 3px;
					font-size: 10pt;
					padding-left: 3px;
					padding-bottom: 3px;
					}

					.vehicles-box                        { border: 1px solid #000; font-weight: bold; margin-bottom: 3px; }
					.vehicles-box div:not(:nth-child(2)) { padding: 0 10px; }
					.vehicles-box span                   { margin-right: 30px; }

					.vehicles_total { font-weight: normal; margin-right: 5px !important; }

					.vehicles-table { font-size: 80%; line-height: 1.2; width: 750px;}
					.vehicles-table td:first-child { font-weight: bold; text-decoration: underline; width: 100px;}
					.vehicles-table td:nth-child(2) { width: 100px;}

					.smaller_font { font-size: 80%; line-height: 1.2; }

					.experience_rate-table { font-size: 90%; line-height: 1.2; margin-bottom: 5px;}
					.experience_rate-table td:first-child { width: 300px;}
					.experience_rate-table td:nth-child(2) { width: 100px;}
					.experience_rate-table td:nth-child(3) { width: 100px;}

				</style>
			</head>
			<body>

				<div id="std_centration">
					<!--new page 1-->
					<div class="std_page">
						<xsl:call-template name="header_block" />

						<div class="title txt_underl falls_lake">
							
						</div>

						<div class="border_box">
							<div class="left">
								<b>Insured</b>
								<br/>
								<xsl:value-of select="$insuredName"/>
								<br/>
								<xsl:value-of select="General/InsuredMailingAddressCity"/>,
								<xsl:value-of select="General/InsuredMailingAddressState"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="General/InsuredMailingAddressZip"/>
							</div>
							<div class="right w250">
								<span class="txt_right">
									<xsl:for-each select="Proposal/ReleaseDate">
										<xsl:value-of select="concat(format-number(Month, '00'), '/', format-number(Day, '00'), '/', Year)"/>
									</xsl:for-each>
								</span>
								<br/>
								<b>Policy:</b>
								<br/>
								<b>FEIN:</b>
								<br/>
								<b>e-mail:</b>
							</div>
						</div>

						<div class="border_box">
							<div class="left">
								<table>
									<tr>
										<td class="w150">
											<b>Description</b>
										</td>
										<td>New</td>
									</tr>
									<tr>
										<td>
											<b>Lock Rates Date</b>
										</td>
										<td>
											<xsl:value-of select="General/EffectiveDate"/>
										</td>
									</tr>
									<tr>
										<td>
											<b>Effective Date</b>
										</td>
										<td>
											<xsl:value-of select="General/EffectiveDate"/>
										</td>
									</tr>
									<tr>
										<td>
											<b>Expiration Date</b>
										</td>
										<td>
											<xsl:value-of select="General/EffectiveDateTo"/>
										</td>
									</tr>
									<tr>
										<td>
											<b>Type of Business</b>
										</td>
										<td>New</td>
									</tr>
									<tr>
										<td>
											<b>Program Name</b>
										</td>
										<td>Business Auto</td>
									</tr>
								</table>
							</div>

							<div class="right w350">
								<div class="right txt_right w200">
									<b class="left">Business Auto</b>
									<xsl:call-template name="print-money">
										<xsl:with-param name="value" select="Proposal/Rating/PremiumForAllVehiclesAndPolicyLevelPremiums"/>
									</xsl:call-template>
								</div>
								<br/>
								<br/>

								<div class="border__top right txt_right w200">
									<b class="left">Total</b>
									<xsl:call-template name="print-money">
										<xsl:with-param name="value" select="Proposal/Rating/PremiumForAllVehiclesAndPolicyLevelPremiums"/>
									</xsl:call-template>
								</div>								
								<div class="right txt_right w350">
									<b class="left">Policy Surcharges and Taxes</b>
									<xsl:call-template name="print-money">
										<xsl:with-param name="value" select="Proposal/Rating/TaxesAndSurcharges"/>
										<xsl:with-param name="format" select="'$#,##0.00'"/>
									</xsl:call-template>
									<div class="border__bottom right txt_right w200">
										<br/>
									</div>
								</div>								
								<div class="left w350">
									<b>POLICY TOTAL</b>
									<div class="w200 border__bottom">
										<xsl:call-template name="print-money">
											<xsl:with-param name="value" select="Proposal/Rating/TotalPremiumForQuote"/>
											<xsl:with-param name="format" select="'$#,##0.00'"/>
										</xsl:call-template>
									</div>
									<div class="w200 border__top right">&#160;</div>
								</div>
							</div>

						</div>

						<div>
							<b>Policy Totals Breakdown</b>
						</div>
						<div class="border_box left_padding">
							<div class="left">
								<table class="business_auto-table smaller_font">
									<tr>
										<td colspan="3">
											<b class="txt_underl">Business Auto</b>
										</td>
										<td colspan="3">
											<b class="txt_underl">Policy / Other</b>
										</td>
									</tr>
									<tr>
										<td class="left_padding"></td>
										<xsl:choose>
											<xsl:when test="$vehiclesCollection/VehicleDescrCheckCoveragesLiability = 'True'">
												<td>
													<b>Liability</b>
												</td>
												<xsl:call-template name="money_cell">
													<xsl:with-param name="value" select="Proposal/Rating/TotalPremiumTable/TotalLiabilityPremium"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<td></td>
												<td></td>
											</xsl:otherwise>
										</xsl:choose>
										<td></td>
										<td>
											<b>Surch / Taxes</b>
										</td>
										<td>
											<xsl:call-template name="print-money">
												<xsl:with-param name="value" select="Proposal/Rating/TaxesAndSurcharges"/>
												<xsl:with-param name="format" select="'$#,##0.00'"/>
											</xsl:call-template>
										</td>
									</tr>
									<xsl:if test="$hiredAutoCoverageSelected">
										<xsl:call-template name="total-premiums-breakdown">
											<xsl:with-param name="coverage" select="'Hired Auto'" />
											<xsl:with-param name="premium" select="$hiredAutoPremium" />
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$nonOwnedAutoCoverageSelected">
										<xsl:call-template name="total-premiums-breakdown">
											<xsl:with-param name="coverage" select="'Non Owned Liability'" />
											<xsl:with-param name="premium" select="$nonOwnedAutoPremium" />
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$vehiclesCollection/VehicleDescrCheckCoveragesNoFaultCoverage = 'True'">
										<xsl:call-template name="total-premiums-breakdown">
											<xsl:with-param name="coverage" select="'PIP'" />
											<xsl:with-param name="premium" select="Proposal/Rating/TotalPremiumTable/PIPTotalPremium" />
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$vehiclesCollection/VehicleDescrCheckCoveragesMedicalPayments = 'True'">
										<xsl:call-template name="total-premiums-breakdown">
											<xsl:with-param name="coverage" select="'Medical Payments'" />
											<xsl:with-param name="premium" select="Proposal/Rating/TotalPremiumTable/TotalMedPayPremium" />
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$vehiclesCollection/VehicleDescrCheckCoveragesUninsuredMotorist = 'True'">
										<xsl:call-template name="total-premiums-breakdown">
											<xsl:with-param name="coverage" select="'UM'" />
											<xsl:with-param name="premium" select="Proposal/Rating/TotalPremiumTable/UMTotalPremium" />
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$vehiclesCollection/VehicleDescrCheckCoveragesUnderinsuredMotorist = 'True'">
										<xsl:call-template name="total-premiums-breakdown">
											<xsl:with-param name="coverage" select="'UIM'" />
											<xsl:with-param name="premium" select="Proposal/Rating/TotalPremiumTable/TotalUnderinsuredMotoristPremium" />
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$vehiclesCollection/VehicleDescrCheckCoveragesCollisionCoverage = 'True'">
										<xsl:call-template name="total-premiums-breakdown">
											<xsl:with-param name="coverage" select="'Collision'" />
											<xsl:with-param name="premium" select="Proposal/Rating/TotalPremiumTable/TotalCollisionPremium" />
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$vehiclesCollection/VehicleDescrCheckCoveragesComprehensiveCoverage = 'True'">
										<xsl:call-template name="total-premiums-breakdown">
											<xsl:with-param name="coverage" select="'Other Than Coll'" />
											<xsl:with-param name="premium" select="Proposal/Rating/TotalPremiumTable/TotalOtcPremium" />
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$vehiclesCollection/VehicleDescrCheckCoveragesTowingAndLabor = 'True'">
										<xsl:call-template name="total-premiums-breakdown">
											<xsl:with-param name="coverage" select="'Towing &amp; Labor'" />
											<xsl:with-param name="premium" select="Proposal/Rating/TotalPremiumTable/TotalTowingAndLaborPremium" />
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$vehiclesCollection/VehicleDescrCheckCoveragesRentalReimbursementCoverage = 'True'">
										<xsl:call-template name="total-premiums-breakdown">
											<xsl:with-param name="coverage" select="'Rental Reimbursement'" />
											<xsl:with-param name="premium" select="Proposal/Rating/TotalPremiumTable/TotalRentalReimbursementPremium" />
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$otherEndorsementsSelected">
										<xsl:call-template name="total-premiums-breakdown">
											<xsl:with-param name="coverage" select="'Other'" />
											<xsl:with-param name="premium" select="Proposal/Rating/EndorsementsAKAOther" />
										</xsl:call-template>
									</xsl:if>
									<tr>
										<td class="left_padding"></td>
										<td class="border__top_">
											<b>Total</b>
										</td>
										<td class="border__top_ txt_right">
											<b>
												<xsl:call-template name="print-money">
													<xsl:with-param name="value" select="Proposal/Rating/PremiumForAllVehiclesAndPolicyLevelPremiums"/>
												</xsl:call-template>
											</b>
										</td>
										<td class="left_padding"></td>
										<td class="border__top_">
											<b>Total</b>
										</td>
										<td class="border__top_">
											<xsl:call-template name="print-money">
												<xsl:with-param name="value" select="Proposal/Rating/TaxesAndSurcharges"/>
												<xsl:with-param name="format" select="'$#,##0.00'"/>
											</xsl:call-template>
										</td>
									</tr>
								</table>
							</div>
						</div>

						<xsl:if test="Proposal/Rating/TaxesAndSurcharges &gt; 0">
							<h1>Policywide Surcharges and Taxes</h1>
							<div class="policywide_s_t-box">
								<div class="txt_right">
									<b class="left txt_underl">BUSINESS AUTO</b>
									<b>Premium</b>
								</div>
							</div>
						</xsl:if>

						<table class="optional_coverage-table smaller_font">
							<xsl:if test="Business/BusinessAutoEnhancementEndorsement = 'True'">
								<h2>Optional Coverages</h2>
									<thead>
										<tr>
											<td>Coverage</td>
											<td>Line</td>
											<td>Exposure</td>
											<td>Premium</td>
										</tr>
									</thead>
										<tr>
											<td>Enhancement Endorsement</td>
											<td>Business Auto</td>
											<td>
												<xsl:call-template name="print-money">
													<xsl:with-param name="value" select="Proposal/Rating/Exposure"/>
												</xsl:call-template>
											</td>
											<td>
												<xsl:call-template name="print-money">
													<xsl:with-param name="value" select="Proposal/Rating/EnhancementEndorsement"/>
												</xsl:call-template>
											</td>
										</tr>
							</xsl:if>
							<tr>
								<td>
									<xsl:if test="Business/EmployeeOperated = 'True'"><br/>Principally Operated by Employees</xsl:if>
									<xsl:if test="VehicleDescrCoveredWorkersCompensation = 'True'"><br/>Covered by Workers' Compensation</xsl:if>
									<xsl:if test="BusinessAuto/UninsuredMotoristsStacked = 'True'"><br/>Uninsured Motorist Stacked</xsl:if>
									<xsl:if test="BusinessAuto/UnderinsuredMotoristsStacked = 'True'"><br/>Underinsured Motorist Stacked</xsl:if>
									<xsl:if test="Business/TortLimitation = 'True'"><br/>With Tort Limitation</xsl:if>
								</td>
							</tr>
						</table>

						<h2>Policy Information - Business Auto</h2>
						<div class="border_box">
							<table class="policy_information-table">
								<tr>
									<td>Legal Entity</td>
									<td>
										<xsl:value-of select="Operations/EntityLabel"/>
									</td>
									<td>
										<b>Type of Fleet</b>
									</td>
									<td>
										<xsl:if test="not(Vehicles/AreThere5OrMoreUnits)">Non-</xsl:if>Fleet
									</td>
								</tr>
								<tr>
									<td>Liability</td>
									<td>
										<xsl:call-template name="print-money">
											<xsl:with-param name="value" select="$liabilityLimit"/>
										</xsl:call-template>
									</td>
									<td>
										<b>CSL Deductible</b>
									</td>
									<td>Full</td>
								</tr>
								<tr>
									<td>NAICS</td>
									<td>
										<xsl:value-of select="Insured/GMINAICS"/>
									</td>
								</tr>
							</table>
						</div>
					</div>
						
				<div class="std_page">
					<xsl:call-template name="header_block" />
					
					<h2>Experience Rating - Business Auto</h2>
						<div class="border_box">
							<table class="experience_rate-table">
								<thead>
									<tr>
										<td colspan="6">
											<b>Liability</b>
										</td>
									</tr>
								</thead>
								<tr>
									<td>Company LC for the Policy Being Rated</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/LiabilityAnnualBasicLimitsCompanyLossCostForThePolicyBeingRated"/>
											<xsl:with-param name="format" select="'#,##0'"/>
										</xsl:call-template>
									</td>
								</tr>
							</table>
							<table class="experience_rate-table">
								<tr>
									<th></th>
									<th class="txt_center">Detrend Factor</th>
									<th class="txt_center">Company LC</th>
								</tr>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Latest Year'" />
									<xsl:with-param name="factor" select="//Proposal/Rating/DetrendFactorsTable/LiabilityLatestYear" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/LiabilityLatestYearAnnualBasicLimitsCompanyLossCostsSubjectToExperienceRating" />
								</xsl:call-template>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Second Latest Year'" />
									<xsl:with-param name="factor" select="//Proposal/Rating/DetrendFactorsTable/LiabilitySecondLatestYear" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/LiabilitySecondLatestYearAnnualBasicLimitsCompanyLossCostsSubjectToExperienceRating" />
								</xsl:call-template>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Third Latest Year'" />
									<xsl:with-param name="factor" select="//Proposal/Rating/DetrendFactorsTable/LiabilityThirdLatestYear" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/LiabilityThirdLatestYearAnnualBasicLimitsCompanyLossCostsSubjectToExperienceRating" />
								</xsl:call-template>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Total'" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/LiabilityCompanySubjectLossCost" />
								</xsl:call-template>
							</table>
							<table class="experience_rate-table">
								<tr>
									<td>Credibility Factor</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/LiabilityCredibilityFactor"/>
											<xsl:with-param name="format" select="'#,##0.000'"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td>Expected Experience Ratio</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/LiabilityExpectedExperienceRatio"/>
											<xsl:with-param name="format" select="'#,##0.000'"/>
										</xsl:call-template>
									</td>
								</tr>
							</table>
							<table class="experience_rate-table">
								<tr>
									<th></th>
									<th class="txt_center">Loss Development Factor</th>
									<th class="txt_center">Adjusted Losses</th>
								</tr>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Latest Year'" />
									<xsl:with-param name="factor" select="//Proposal/Rating/EperienceRatingTable/LiabilityLatestYearLossDevelopmentFactor" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/LiabilityLatestYearAdjustmentToReflectTheUltimateLevelOfLosses" />
								</xsl:call-template>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Second Latest Year'" />
									<xsl:with-param name="factor" select="//Proposal/Rating/EperienceRatingTable/LiabilitySecondLatestYearLossDevelopmentFactor" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/LiabilitySecondLatestYearAdjustmentToReflectTheUltimateLevelOfLosses" />
								</xsl:call-template>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Third Latest Year'" />
									<xsl:with-param name="factor" select="//Proposal/Rating/EperienceRatingTable/LiabilityThirdLatestYearLossDevelopmentFactor" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/LiabilityThirdLatestYearAdjustmentToReflectTheUltimateLevelOfLosses" />
								</xsl:call-template>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Total'" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/LiabilityTotalAdjustmentToReflectTheUltimateLevelOfLosses" />
								</xsl:call-template>
							</table>
							<table class="experience_rate-table">
								<tr>
									<td>MSL Value</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/MSLTable/LiabilityMSL"/>
											<xsl:with-param name="format" select="'#,##0'"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td>Total Experience Period Includable Limited Losses</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/LiabilityTotalExperiencePeriodIncludableLimitedLosses"/>
											<xsl:with-param name="format" select="'#,##0'"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td>Total Includable Losses</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/LiabilityTotalIncludableLosses"/>
											<xsl:with-param name="format" select="'#,##0'"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td>Actual Experience Ratio</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/LiabilityActualExperienceRatio"/>
											<xsl:with-param name="format" select="'#,##0.000'"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td>Experience Rate</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/LiabilityExperienceRatingModificationFactor"/>
											<xsl:with-param name="format" select="'#,##0.000'"/>
										</xsl:call-template>
									</td>
								</tr>
							</table>
						</div>
						<div class="border_box">
							<table class="experience_rate-table">
								<thead>
									<tr>
										<td colspan="6">
											<b>Physical Damage</b>
										</td>
									</tr>
								</thead>
								<tr>
									<td>Company LC for the Policy Being Rated</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageAnnualBasicLimitsCompanyLossCostForThePolicyBeingRated"/>
											<xsl:with-param name="format" select="'#,##0'"/>
										</xsl:call-template>
									</td>
								</tr>
							</table>
							<table class="experience_rate-table">
								<tr>
									<th></th>
									<th class="txt_center">Detrend Factor</th>
									<th class="txt_center">Company LC</th>
								</tr>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Latest Year'" />
									<xsl:with-param name="factor" select="//Proposal/Rating/DetrendFactorsTable/PhysicalDamageLatestYear" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageLatestYearAnnualBasicLimitsCompanyLossCostsSubjectToExperienceRating" />
								</xsl:call-template>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Second Latest Year'" />
									<xsl:with-param name="factor" select="//Proposal/Rating/DetrendFactorsTable/PhysicalDamageSecondLatestYear" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageSecondLatestYearAnnualBasicLimitsCompanyLossCostsSubjectToExperienceRating" />
								</xsl:call-template>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Third Latest Year'" />
									<xsl:with-param name="factor" select="//Proposal/Rating/DetrendFactorsTable/PhysicalDamageThirdLatestYear" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageThirdLatestYearAnnualBasicLimitsCompanyLossCostsSubjectToExperienceRating" />
								</xsl:call-template>
								<xsl:call-template name="experience-factor-breakdown">
									<xsl:with-param name="year" select="'Total'" />
									<xsl:with-param name="loss" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageCompanySubjectLossCost" />
								</xsl:call-template>
							</table>
							<table class="experience_rate-table">
								<tr>
									<td>Credibility Factor</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageCredibilityFactor"/>
											<xsl:with-param name="format" select="'#,##0.000'"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td>Expected Experience Ratio</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageExpectedExperienceRatio"/>
											<xsl:with-param name="format" select="'#,##0.000'"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td>MSL Value</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/MSLTable/PhysicalDamageMSL"/>
											<xsl:with-param name="format" select="'#,##0'"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td>Total Includable Losses</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageTotalIncludableLosses"/>
											<xsl:with-param name="format" select="'#,##0'"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td>Actual Experience Ratio</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageActualExperienceRatio"/>
											<xsl:with-param name="format" select="'#,##0.000'"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td>Experience Rate</td>
									<td>
										<xsl:call-template name="rate_cell">
											<xsl:with-param name="value" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageExperienceRatingModificationFactor"/>
											<xsl:with-param name="format" select="'#,##0.000'"/>
										</xsl:call-template>
									</td>
								</tr>
							</table>
						</div>
					</div>

					<xsl:for-each select="Location/LocationRows/*">
						<xsl:variable name="loc" select="LocationNumber"/>
						<xsl:variable name="loc-state" select="Location/State"/>
						<xsl:variable name="vehiclesByGaragedLocationNumber"
									  select="//Vehicle/VehicleDescriptionRows/*[VehicleDescrLoc = $loc]"/>
						<xsl:variable name="locationPremium"
									  select="//Proposal/Rating/PremiumsByLocation/PremiumsByLocationCollection[LocationNumber = $loc][1]"/>

						<div class="std_page">
							<xsl:call-template name="header_block" />

							<h1>Location
								<xsl:value-of select="$loc"/>&#160;
								Vantapro Specialty Insurance Company Proposal
							</h1>
							<div class="location_falls_lake-box">
								<table class="location_falls_lake-table">
									<tr>
										<td>
											<xsl:value-of select="Location/Street"/>
											<br/>
											<xsl:value-of select="Location/City"/>,
											<xsl:value-of select="Location/State"/>&#160;
											<xsl:value-of select="Location/Zip"/>
											<br/>
											<xsl:value-of select="Location/County"/>
										</td>
										<td>
											<div class="w200 right txt_right">
												<b class="left">Business Auto</b>
												<xsl:call-template name="print-money">
													<xsl:with-param name="value" select="$locationPremium/TotalPremiumByLocation"/>
												</xsl:call-template>
											</div>
											<br/>
											<br/>
											<div class="w200 border__top right txt_right">
												<b class="left">Total</b>
												<span>
													<xsl:call-template name="print-money">
														<xsl:with-param name="value" select="$locationPremium/TotalPremiumByLocation"/>
													</xsl:call-template>
												</span>
											</div>
										</td>
									</tr>
								</table>
							</div>

							<div>
								<h2>Business Auto</h2>
								<div class="business_auto-box">
									<div class="left">
										<b>Territory</b>
										<xsl:text> </xsl:text>
										<xsl:value-of select="$locationPremium/Territory" />
									</div>
									<table class="business_auto-table right">
										<thead>
											<tr>
												<td colspan="6">
													<b>Total Fleet Premium Information...</b>
												</td>
											</tr>
										</thead>
										<xsl:if test="$vehiclesByGaragedLocationNumber/VehicleDescrCheckCoveragesLiability = 'True'">
											<xsl:call-template name="total-premiums-breakdown">
												<xsl:with-param name="coverage" select="'Liability'" />
												<xsl:with-param name="premium" select="$locationPremium/LiabilityPremium" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$loc = 1">
											<xsl:if test="$hiredAutoCoverageSelected">
												<xsl:call-template name="total-premiums-breakdown">
													<xsl:with-param name="coverage" select="'Hired Auto'" />
													<xsl:with-param name="premium" select="$hiredAutoPremium" />
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$nonOwnedAutoCoverageSelected">
												<xsl:call-template name="total-premiums-breakdown">
													<xsl:with-param name="coverage" select="'Non Owned Liability'" />
													<xsl:with-param name="premium" select="$nonOwnedAutoPremium" />
												</xsl:call-template>
											</xsl:if>
										</xsl:if>	
										<xsl:if test="$vehiclesByGaragedLocationNumber/VehicleDescrCheckCoveragesNoFaultCoverage = 'True'">
											<xsl:call-template name="total-premiums-breakdown">
												<xsl:with-param name="coverage" select="'PIP'" />
												<xsl:with-param name="premium" select="$locationPremium/PIPTotalPremium" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$vehiclesByGaragedLocationNumber/VehicleDescrCheckCoveragesMedicalPayments = 'True'">
											<xsl:call-template name="total-premiums-breakdown">
												<xsl:with-param name="coverage" select="'Medical Payments'" />
												<xsl:with-param name="premium" select="$locationPremium/MedPayPremium" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$vehiclesByGaragedLocationNumber/VehicleDescrCheckCoveragesUninsuredMotorist = 'True'">
											<xsl:call-template name="total-premiums-breakdown">
												<xsl:with-param name="coverage" select="'UM'" />
												<xsl:with-param name="premium" select="$locationPremium/UMTotalPremium" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$vehiclesByGaragedLocationNumber/VehicleDescrCheckCoveragesUnderinsuredMotorist = 'True'">
											<xsl:call-template name="total-premiums-breakdown">
												<xsl:with-param name="coverage" select="'UIM'" />
												<xsl:with-param name="premium" select="$locationPremium/UnderinsuredMotoristPremium" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$vehiclesByGaragedLocationNumber/VehicleDescrCheckCoveragesComprehensiveCoverage = 'True'">
											<xsl:call-template name="total-premiums-breakdown">
												<xsl:with-param name="coverage" select="'OTC'" />
												<xsl:with-param name="premium" select="$locationPremium/OTCPremium" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$vehiclesByGaragedLocationNumber/VehicleDescrCheckCoveragesCollisionCoverage = 'True'">
											<xsl:call-template name="total-premiums-breakdown">
												<xsl:with-param name="coverage" select="'Collision'" />
												<xsl:with-param name="premium" select="$locationPremium/CollisionPremium" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$vehiclesByGaragedLocationNumber/VehicleDescrCheckCoveragesTowingAndLabor = 'True'">
											<xsl:call-template name="total-premiums-breakdown">
												<xsl:with-param name="coverage" select="'Towing &amp; Labor'" />
												<xsl:with-param name="premium" select="$locationPremium/TowingAndLabor" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="//Business/AudioVisual = 'True'">
											<xsl:call-template name="total-premiums-breakdown">
												<xsl:with-param name="coverage" select="'Audio &amp; Visual'" />
												<xsl:with-param name="premium" select="$locationPremium/AudioVisualPremium" />
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$vehiclesByGaragedLocationNumber/VehicleDescrCheckCoveragesRentalReimbursementCoverage = 'True'">
											<xsl:call-template name="total-premiums-breakdown">
												<xsl:with-param name="coverage" select="'Rental Reimbursement'" />
												<xsl:with-param name="premium" select="$locationPremium/RentalReimbursementPremium" />
											</xsl:call-template>
										</xsl:if>
										<tr>
											<td></td>
											<td class="border__top_">
												<b>Fleet Grand Total</b>
											</td>
											<td class="border__top_ txt_right">
												<xsl:call-template name="print-money">
													<xsl:with-param name="value" select="$locationPremium/TotalPremiumByLocation"/>
												</xsl:call-template>
											</td>
											<td colspan="3"></td>
										</tr>
									</table>
								</div>
								<xsl:if test="$loc = 1">
									<xsl:if test="$hiredAutoCoverageSelected">
										<div class="business_auto-blsec">
											<b>Hired Auto: Liability class 6625<xsl:if test="//BusinessAuto/HiredPhysicalDamageCoverageDeductibleComprehensive &gt; 0
											or BusinessAuto/HiredPhysicalDamageCoverageDeductibleCollision &gt; 0">, Physical Damage class 6619</xsl:if></b>
												<table class="vehicles-table">
													<tr>
														<th></th>
														<th class="txt_center">Limit/Ded</th>
														<th class="txt_center">LC</th>
														<th class="txt_center">LCM</th>
														<th class="txt_center">ILF</th>
														<th></th>
														<th></th>
														<th class="txt_center">Cost</th>
														<th></th>
														<th></th>
														<th class="txt_center">ER</th>
														<th class="txt_right">Premium</th>
													</tr>
													<xsl:call-template name="vehicle-premiums-breakdown">
														<xsl:with-param name="coverage" select="'Liability'" />
														<xsl:with-param name="limit" select="$liabilityLimit" />
														<xsl:with-param name="loss-cost" select="//Proposal/Rating/PolicyLevelPremiumTable/HiredAutoLiabilityLossCost" />
														<xsl:with-param name="loss-cost-multiplier" select="//Proposal/Rating/PolicyLevelPremiumTable/LiabilityLossCostMultiplier" />
														<xsl:with-param name="increased-liability-factor" select="//Proposal/Rating/PolicyLevelPremiumTable/IncreasedLiabilityFactor" />
														<xsl:with-param name="additional-factor-1">
															<xsl:choose>
																<xsl:when test="//BusinessAuto/HiredBorrowedLiabilityIfAnyBasis = 'True'">If Any</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="//BusinessAuto/HiredBorrowedLiabilityCostOfHire"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:with-param>
														<xsl:with-param name="is-string" select="//BusinessAuto/HiredBorrowedLiabilityIfAnyBasis = 'True'" />
														<xsl:with-param name="experience-rate" select="//Proposal/Rating/PolicyLevelPremiumTable/HiredAutoLiabilityModificationFactor" />
														<xsl:with-param name="premium" select="//Proposal/Rating/PolicyLevelPremiumTable/HiredAutoLiability"/>
													</xsl:call-template>
													<xsl:if test ="//BusinessAuto/HiredPhysicalDamageCoverageDeductibleComprehensive &gt; 0">
														<xsl:call-template name="vehicle-premiums-breakdown">
															<xsl:with-param name="coverage" select="'Comprehensive'" />
															<xsl:with-param name="limit" select="//BusinessAuto/HiredPhysicalDamageCoverageDeductibleComprehensive" />
															<xsl:with-param name="loss-cost" select="//Proposal/Rating/PolicyLevelPremiumTable/HiredAutoOTCLossCost" />
															<xsl:with-param name="loss-cost-multiplier" select="//Proposal/Rating/PolicyLevelPremiumTable/PhysicalDamageLossCostMultiplier" />
															<xsl:with-param name="increased-liability-factor" select="''"/>
															<xsl:with-param name="additional-factor-1" select="//BusinessAuto/HiredBorrowedLiabilityCostOfHire"/>
															<xsl:with-param name="experience-rate" select="//Proposal/Rating/PolicyLevelPremiumTable/HiredAutoOTCModificationFactor" />
															<xsl:with-param name="premium" select="//Proposal/Rating/PolicyLevelPremiumTable/HiredAutoOTC"/>
														</xsl:call-template>
													</xsl:if>
													<xsl:if test ="BusinessAuto/HiredPhysicalDamageCoverageDeductibleCollision &gt; 0">
														<xsl:call-template name="vehicle-premiums-breakdown">
															<xsl:with-param name="coverage" select="'Collision'" />
															<xsl:with-param name="limit" select="BusinessAuto/HiredPhysicalDamageCoverageDeductibleCollision" />
															<xsl:with-param name="loss-cost" select="//Proposal/Rating/PolicyLevelPremiumTable/HiredAutoCollisionLossCost" />
															<xsl:with-param name="loss-cost-multiplier" select="//Proposal/Rating/PolicyLevelPremiumTable/PhysicalDamageLossCostMultiplier" />
															<xsl:with-param name="increased-liability-factor" select="''"/>
															<xsl:with-param name="additional-factor-1" select="//BusinessAuto/HiredBorrowedLiabilityCostOfHire"/>
															<xsl:with-param name="experience-rate" select="//Proposal/Rating/PolicyLevelPremiumTable/HiredAutoCollisionModificationFactor" />
															<xsl:with-param name="premium" select="//Proposal/Rating/PolicyLevelPremiumTable/HiredAutoCollision"/>
														</xsl:call-template>
													</xsl:if>
												</table>
											</div>
										</xsl:if>
										<xsl:if test="$nonOwnedAutoCoverageSelected">
										<div class="business_auto-blsec">
											<b>Non-Owned Auto class
												<xsl:value-of select="$nonOwnedClassCode" />
												(<xsl:value-of select="//BusinessAuto/NonOwnedLiabilityGroupTypeEmployeesNum"/> Employees)</b>

											<xsl:if test="$nonOwnedAutoCoverageSelected">
												<table class="vehicles-table">
													<tr>
														<th></th>
														<th class="txt_center">Limit</th>
														<th class="txt_center">LC</th>
														<th class="txt_center">LCM</th>
														<th class="txt_center">ILF</th>
														<th></th>
														<th></th>
														<th></th>
														<th></th>
														<th></th>
														<th class="txt_center">ER</th>
														<th class="txt_right">Premium</th>
													</tr>
													<xsl:call-template name="vehicle-premiums-breakdown">
														<xsl:with-param name="coverage" select="'Liability'" />
														<xsl:with-param name="limit" select="$liabilityLimit" />
														<xsl:with-param name="loss-cost" select="//Proposal/Rating/PolicyLevelPremiumTable/NonOwnedLiabilityLossCost" />
														<xsl:with-param name="loss-cost-multiplier" select="//Proposal/Rating/PolicyLevelPremiumTable/LiabilityLossCostMultiplier" />
														<xsl:with-param name="increased-liability-factor" select="//Proposal/Rating/PolicyLevelPremiumTable/IncreasedLiabilityFactor" />
														<xsl:with-param name="experience-rate" select="//Proposal/Rating/PolicyLevelPremiumTable/NonOwnedLiabilityModificationFactor" />
														<xsl:with-param name="premium" select="$nonOwnedAutoPremium"/>
													</xsl:call-template>
												</table>
											</xsl:if>
										</div>
									</xsl:if>
								</xsl:if>
							</div>
							<br/>
							<h4>Vehicles</h4>
							<xsl:for-each select="$vehiclesByGaragedLocationNumber[position() &lt; 3]">
								<xsl:call-template name="vehicle">
									<xsl:with-param name="location-state" select="$loc-state"/>
								</xsl:call-template>
							</xsl:for-each>
						</div>

						<xsl:call-template name="vehiclePage">
							<xsl:with-param name="location-state" select="$loc-state"/>
							<xsl:with-param name="vehicle" select="$vehiclesByGaragedLocationNumber"/>
							<xsl:with-param name="max" select="count($vehiclesByGaragedLocationNumber)"/>
						</xsl:call-template>
					</xsl:for-each>
				</div>

			</body>
		</html>
	</xsl:template>

	<xsl:template name="header_block">
		<xsl:variable name="insuredName" select="//General/InsuredName" />
		<div class="header_block">
			<xsl:value-of select="$insuredName"/>
			<br/>Quote ID:
		</div>
	</xsl:template>
	
	<xsl:template name="money_cell">
		<xsl:param name="value" />
		<xsl:param name="is-string" />
		<td class="txt_right">
			<xsl:choose>
				<xsl:when test="$is-string">
					<xsl:value-of select="$value" />
				</xsl:when>
				<xsl:when test="contains($value, 'Incl') or contains($value, 'incl')">
					Incl
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="print-money">
						<xsl:with-param name="value" select="$value" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>
	
	<xsl:template name="print-money">
		<xsl:param name="value"/>
		<xsl:param name="nilOutput">-</xsl:param>
		<xsl:param name="format">$#,##0</xsl:param>
		<xsl:variable name="outputValue" select="format-number($value, '###0.00', 'decimal')" />
		<xsl:choose>
			<xsl:when test="$outputValue = 0">
				<xsl:value-of select="$nilOutput"/>
			</xsl:when>
			<xsl:when test="$outputValue &gt; 0">
				<xsl:value-of select="format-number($outputValue, $format)"/>
			</xsl:when>
			<xsl:otherwise>
				(<xsl:value-of select="format-number($outputValue, $format)"/>)
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="rate_cell">
		<xsl:param name="value" />
		<xsl:param name="nilOutput"></xsl:param>
		<xsl:param name="format">$#,##0</xsl:param>
		<xsl:param name="is-string" />
		<xsl:variable name="outputValue" select="format-number($value, '###0.000', 'decimal')" />
		<td class="txt_center">
			<xsl:choose>
				<xsl:when test="$is-string">
					<xsl:value-of select="$value" />
				</xsl:when>
				<xsl:when test="$outputValue = 0">
					<xsl:value-of select="$nilOutput"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number($outputValue, $format)"/>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>
	
	<xsl:template name="experience-factor-breakdown">
		<xsl:param name="year" />
		<xsl:param name="factor" />
		<xsl:param name="loss" />
		<tr>
			<td><xsl:value-of select="$year" /></td>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="value" select="$factor"/>
				<xsl:with-param name="format" select="'#,##0.000'"/>
			</xsl:call-template>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="value" select="$loss"/>
				<xsl:with-param name="format" select="'#,##0'"/>
			</xsl:call-template>
		</tr>
	</xsl:template>
	
	<xsl:template name="total-premiums-breakdown">
		<xsl:param name="coverage" />
		<xsl:param name="premium" />
		<tr>
			<td class="w10"></td>
			<td><xsl:value-of select="$coverage" /></td>
			<xsl:call-template name="money_cell">
				<xsl:with-param name="value" select="$premium"/>
			</xsl:call-template>
			<td colspan="3"></td>
		</tr>
	</xsl:template>
	
	<xsl:template name="vehicle-premiums-breakdown">
		<xsl:param name="coverage" />
		<xsl:param name="limit" />
		<xsl:param name="loss-cost" />
		<xsl:param name="loss-cost-multiplier" />
		<xsl:param name="increased-liability-factor" />
		<xsl:param name="class-factor" />
		<xsl:param name="fleet-factor" />
		<xsl:param name="additional-factor-1" />
		<xsl:param name="additional-factor-2" />
		<xsl:param name="additional-factor-3" />
		<xsl:param name="experience-rate" />
		<xsl:param name="premium" />
		<xsl:param name="is-string" />
		<tr>
			<td>
				<xsl:value-of select="$coverage" />
			</td>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="is-string" select="$is-string"/>
				<xsl:with-param name="value" select="$limit"/>
				<xsl:with-param name="format" select="'$#,##0'"/>
			</xsl:call-template>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="value" select="$loss-cost"/>
				<xsl:with-param name="format" select="'#,##0'"/>
			</xsl:call-template>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="value" select="$loss-cost-multiplier"/>
				<xsl:with-param name="format" select="'#,##0.000'"/>
			</xsl:call-template>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="value" select="$increased-liability-factor"/>
				<xsl:with-param name="format" select="'#,##0.000'"/>
			</xsl:call-template>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="value" select="$class-factor"/>
				<xsl:with-param name="format" select="'#,##0.000'"/>
			</xsl:call-template>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="value" select="$fleet-factor"/>
				<xsl:with-param name="format" select="'#,##0.000'"/>
			</xsl:call-template>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="is-string" select="$is-string"/>
				<xsl:with-param name="value" select="$additional-factor-1"/>
				<xsl:with-param name="format" select="'#,##0.000'"/>
			</xsl:call-template>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="value" select="$additional-factor-2"/>
				<xsl:with-param name="format" select="'#,##0.000'"/>
			</xsl:call-template>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="value" select="$additional-factor-3"/>
				<xsl:with-param name="format" select="'#,##0.000'"/>
			</xsl:call-template>
			<xsl:call-template name="rate_cell">
				<xsl:with-param name="value" select="$experience-rate"/>
				<xsl:with-param name="format" select="'#,##0.000'"/>
			</xsl:call-template>
			<xsl:call-template name="money_cell">
				<xsl:with-param name="value" select="$premium"/>
			</xsl:call-template>
		</tr>
	</xsl:template>
	
	<xsl:template name="vehiclePage">
		<xsl:param name="vehicle"/>
		<xsl:param name="location-state"/>
		<xsl:param name="min" select="3" />
		<xsl:param name="max" />
		<xsl:param name="vehiclesPerPage" select="5" />

		<xsl:if test="$min &lt; $max">
			<div class="std_page">
				<xsl:if test="$vehicle[position() = $min]">
					<xsl:call-template name="header_block" />
				</xsl:if>
				<xsl:for-each select="$vehicle[position() &gt;= $min][position() &lt;= $vehiclesPerPage]">
						<xsl:call-template name="vehicle">
							<xsl:with-param name="location-state" select="$location-state" />
						</xsl:call-template>
				</xsl:for-each>
			</div>
			<xsl:call-template name="vehiclePage">
				<xsl:with-param name="vehicle" select="$vehicle" />
				<xsl:with-param name="location-state" select="$location-state" />
				<xsl:with-param name="min" select="$min + $vehiclesPerPage" />
				<xsl:with-param name="max" select="$max" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="vehicle">
		<xsl:param name="location-state" />
		<xsl:variable name="vehicleNum" select="VehicleDescrVehicleNum"/>
		<xsl:variable name="vehiclePremium" select="//Proposal/Rating/Premiums/Premium[VehicleNumber = $vehicleNum]"/>	
		<div class="vehicles-box">
			<div>
				Vehicle #
				<xsl:value-of select="$vehicleNum"/>&#160;
				<xsl:value-of select="VehicleDescrlblVehicleType"/>&#160;
				<xsl:value-of select="VehicleDescr/GMIModelYear"/>&#160;
				<xsl:value-of select="VehicleDescr/GMIManufacturer"/>&#160;
				<xsl:value-of select="VehicleDescr/GMIModel"/>&#160;
				<xsl:value-of select="VehicleDescrVIN"/>
			</div>
			<div class="right w200">
				Vehicle Total
				<div class="right txt_right vehicles_total">
					<xsl:call-template name="print-money">
						<xsl:with-param name="value" select="$vehiclePremium/TotalPremiumByVehicle"/>
					</xsl:call-template>
				</div>
			</div>
			<div>
				<span>
					<xsl:choose>
						<xsl:when test="VehicleDescrDeductibleBasedOnStatedAmountBasis = 'True'">Stated Amount</xsl:when>
						<xsl:otherwise>Cost New</xsl:otherwise>
					</xsl:choose>
					&#160;
					<xsl:call-template name="print-money">
						<xsl:with-param name="value" select="VehicleDescr/GMIValue"/>
					</xsl:call-template>
				</span>
				<span>
					Code&#160;<xsl:value-of select="$vehiclePremium/DescrClassificationCode"/>
				</span>
				<span>
					Age Group&#160;<xsl:value-of select="$vehiclePremium/AgeGroup"/>
				</span>
			</div>
		</div>

		
		<xsl:if test="VehicleDescrCheckCoveragesLiability = 'True'">
			<table class="vehicles-table">
				<tr>
					<th></th>
					<th class="txt_center">Limit</th>
					<th class="txt_center">LC</th>
					<th class="txt_center">LCM</th>
					<th class="txt_center">ILF</th>
					<th class="txt_center">Class</th>
					<th class="txt_center">Fleet</th>
					<th class="txt_center">
						<xsl:if test="$vehiclePremium/OptionalClassPlan = 'True'">Age</xsl:if>
						<xsl:if test="$location-state = 'NJ'">Tort</xsl:if>
					</th>
					<th class="txt_center">
						<xsl:if test="$vehiclePremium/OptionalClassPlan = 'True'">Cost</xsl:if>
					</th>
					<th class="txt_center">
						<xsl:if test="$vehiclePremium/OptionalClassPlan = 'True'">NAICS</xsl:if>
					</th>
					<th class="txt_center">ER</th>
					<th class="txt_right">Premium</th>
				</tr>
				<xsl:call-template name="vehicle-premiums-breakdown">
					<xsl:with-param name="coverage" select="'Liability'" />
					<xsl:with-param name="limit" select="//BusinessAuto/LiabilityLimitsCSLAmount" />
					<xsl:with-param name="loss-cost" select="$vehiclePremium/LiabilityLossCost" />
					<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
					<xsl:with-param name="increased-liability-factor" select="$vehiclePremium/LiabilityIncreasedLiabilityFactor" />
					<xsl:with-param name="class-factor" select="$vehiclePremium/LiabilityClassFactor" />
					<xsl:with-param name="fleet-factor" select="$vehiclePremium/LiabilityFleetFactor" />
					<xsl:with-param name="additional-factor-1">
						<xsl:if test="$vehiclePremium/OptionalClassPlan = 'True'">
							<xsl:value-of select="$vehiclePremium/LiabilityAgeFactor" />
						</xsl:if>
						<xsl:if test="$location-state = 'NJ'">
							<xsl:value-of select="$vehiclePremium/LiabilityTortFactor" />
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="additional-factor-2">
						<xsl:if test="$vehiclePremium/OptionalClassPlan = 'True'">
							<xsl:value-of select="$vehiclePremium/LiabilityCostFactor" />
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="additional-factor-3">
						<xsl:if test="$vehiclePremium/OptionalClassPlan = 'True'">
							<xsl:value-of select="$vehiclePremium/LiabilityNAICSFactor" />
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="experience-rate" select="$vehiclePremium/LiabilityModificationFactor" />
					<xsl:with-param name="premium" select="$vehiclePremium/LiabilityPremium" />
				</xsl:call-template>
			</table>
		</xsl:if>
		<table class="vehicles-table">
			<xsl:if test="VehicleDescrCheckCoveragesNoFaultCoverage = 'True' or VehicleDescrlblCheckCoverages/Pedestrian = 'True'">
				<tr>
					<th></th>
					<th class="txt_center">Limit</th>
					<th class="txt_center">LC</th>
					<th class="txt_center">LCM</th>
					<th></th>
					<th></th>
					<th></th>
					<th class="txt_center">
						<xsl:choose>
							<xsl:when test="$location-state = 'NJ'">Tort</xsl:when>
							<xsl:when test="$location-state = 'FL'or $location-state = 'PA'">Zone</xsl:when>
							<xsl:when test="$location-state = 'TX'">ILF</xsl:when>
						</xsl:choose>
					</th>
					<th class="txt_center"><xsl:if test="$location-state = 'FL'or $location-state = 'PA'">Class</xsl:if></th>
					<th class="txt_center"><xsl:if test="$location-state = 'FL'or $location-state = 'PA'">Fleet</xsl:if></th>
					<th></th>
					<th class="txt_right">Premium</th>
				</tr>
				<xsl:if test="VehicleDescrCheckCoveragesNoFaultCoverage = 'True'">
					<xsl:call-template name="vehicle-premiums-breakdown">
						<xsl:with-param name="coverage">
							<xsl:choose >
								<xsl:when test="$location-state = 'PA'">Basic FPB</xsl:when>
								<xsl:otherwise>PIP</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="limit">
							<xsl:if test="$location-state = 'TX'"><xsl:value-of select="//BusinessAuto/CompulsoryPersonalInjuryProtectionLimitsBIEaPer"/></xsl:if>
						</xsl:with-param>
						<xsl:with-param name="loss-cost">
							<xsl:if test="$location-state = 'NJ'"><xsl:value-of select="$vehiclePremium/BasicPIPLossCostNJ"/></xsl:if>
							<xsl:if test="$location-state = 'FL'or $location-state = 'PA'"><xsl:value-of select="$vehiclePremium/BasicPIPLossCostFLPA"/></xsl:if>
							<xsl:if test="$location-state = 'TX'"><xsl:value-of select="$vehiclePremium/BasicPIPLossCostTX"/></xsl:if>
						</xsl:with-param>
						<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
						<xsl:with-param name="additional-factor-1">
							<xsl:if test="$location-state = 'NJ'"><xsl:value-of select="$vehiclePremium/BasicPIPTortFactorNJ"/></xsl:if>
							<xsl:if test="$location-state = 'FL'or $location-state = 'PA'"><xsl:value-of select="$vehiclePremium/BasicPIPZoneFactorFLPA"/></xsl:if>
							<xsl:if test="$location-state = 'TX'"><xsl:value-of select="$vehiclePremium/BasicPIPIncreasedLiabilityFactorTX"/></xsl:if>
						</xsl:with-param>
						<xsl:with-param name="additional-factor-2">
							<xsl:if test="$location-state = 'FL'or $location-state = 'PA'"><xsl:value-of select="$vehiclePremium/BasicPIPClassFactorFLPA"/></xsl:if>
						</xsl:with-param>
						<xsl:with-param name="additional-factor-3">
							<xsl:if test="$location-state = 'FL'or $location-state = 'PA'"><xsl:value-of select="$vehiclePremium/BasicPIPFleetFactorFLPA"/></xsl:if>
						</xsl:with-param>								
						<xsl:with-param name="premium" select="$vehiclePremium/BasicPIPPremium" />
					</xsl:call-template>
					<xsl:if test="//BusinessAuto/CompulsoryPersonalInjuryProtectionLimitsExtendedMedicalExpenseBenefits = 'True' and $location-state = 'NJ'">
						<xsl:call-template name="vehicle-premiums-breakdown">
							<xsl:with-param name="coverage" select="'Ext Med'" />
							<xsl:with-param name="limit" select="//BusinessAuto/CompulsoryPersonalInjuryProtectionLimitsExtendedMedicalExpenseEachPerson" />
							<xsl:with-param name="premium" select="$vehiclePremium/ExtendedMedicalBenefitsPremium" />
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				<xsl:if test="VehicleDescrlblCheckCoverages/Pedestrian = 'True'">
					<xsl:call-template name="vehicle-premiums-breakdown">
						<xsl:with-param name="coverage" select="'Pedestrian'" />
						<xsl:with-param name="loss-cost" select="$vehiclePremium/PedestrianOrPIPLossCost" />
						<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
						<xsl:with-param name="additional-factor-1" select="$vehiclePremium/PedestrianOrPIPTortFactor" />
						<xsl:with-param name="premium" select="$vehiclePremium/PedestrianOrPIPPremium" />
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$location-state = 'PA'">
					<xsl:if test="//BusinessAuto/CompulsoryPersonalInjuryProtectionLimitsMedExpCov = 'True'">
						<xsl:call-template name="vehicle-premiums-breakdown">
							<xsl:with-param name="coverage" select="'Medical Expense Benefits'" />
							<xsl:with-param name="limit" select="//Business/FirstPartyBenefitsLimitsMedicalExpense" />
							<xsl:with-param name="loss-cost" select="$vehiclePremium/MedicalExpenseBenefitsLossCost" />
							<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
							<xsl:with-param name="premium" select="$vehiclePremium/MedicalExpenseBenefitsPremium" />
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="//BusinessAuto/CompulsoryPersonalInjuryProtectionLimitsWorkLossCov = 'True'">
						<xsl:call-template name="vehicle-premiums-breakdown">
							<xsl:with-param name="coverage" select="'Work Loss Benefits'" />
							<xsl:with-param name="limit">
								<xsl:variable name="workLoss" select="//Business/FirstPartyBenefitsLimitsWorkLossSel" />
								<xsl:if test="$workLoss = '1,000 / 5,000'">$1,000 Monthly/$5,000 Total</xsl:if>
								<xsl:if test="$workLoss = '1,000 / 15,000'">$1,000 Monthly/$15,000 Total</xsl:if>
								<xsl:if test="$workLoss = '1,500 / 25,000'">$1,500 Monthly/$25,000 Total</xsl:if>
								<xsl:if test="$workLoss = '2,500 / 50,000'">$2,500 Monthly/$50,000 Total</xsl:if>
							</xsl:with-param>
							<xsl:with-param name="loss-cost" select="$vehiclePremium/WorkLossBenefitsLossCost" />
							<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
							<xsl:with-param name="premium" select="$vehiclePremium/WorkLossBenefitsPremium" />
							<xsl:with-param name="is-string" select="$location-state = 'PA'" />
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="//BusinessAuto/CompulsoryPersonalInjuryProtectionLimitFunExpCov = 'True'">
						<xsl:call-template name="vehicle-premiums-breakdown">
							<xsl:with-param name="coverage" select="'Funeral Expense Benefits'" />
							<xsl:with-param name="limit" select="//Business/FirstPartyBenefitsLimitsFuneralExpense" />
							<xsl:with-param name="loss-cost" select="$vehiclePremium/FuneralExpenseBenefitsLossCost" />
							<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
							<xsl:with-param name="premium" select="$vehiclePremium/FuneralExpenseBenefitsPremium" />
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="//BusinessAuto/CompulsoryPersonalInjuryProtectionLimitsAccDeathY = 'True'">
						<xsl:call-template name="vehicle-premiums-breakdown">
							<xsl:with-param name="coverage" select="'Accidental Death Benefits'" />
							<xsl:with-param name="limit" select="//Business/FirstPartyBenefitsLimitsAccidentalDeath" />
							<xsl:with-param name="loss-cost" select="$vehiclePremium/AccidentalDeathBenefitsLossCost" />
							<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
							<xsl:with-param name="premium" select="$vehiclePremium/AccidentalDeathBenefitsPremium" />
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="//Business/CombinationFirstPartyBenefits = 'True'">
						<xsl:call-template name="vehicle-premiums-breakdown">
							<xsl:with-param name="coverage" select="'Combination First Party Benefits'" />
							<xsl:with-param name="limit" select="//Business/CombinationFirstPartyBenLimitsTotalLimit" />
							<xsl:with-param name="loss-cost" select="$vehiclePremium/CombinationFirstPartyBenefitsLossCost" />
							<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
							<xsl:with-param name="premium" select="$vehiclePremium/CombinationFirstPartyBenefitsPremium" />
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="//Business/ExtraordinaryMedicalBenefits = 'True'">
						<xsl:call-template name="vehicle-premiums-breakdown">
							<xsl:with-param name="coverage" select="'Extraordinary Medical Benefits'" />
							<xsl:with-param name="limit" select="//Business/ExtraordMedBenLimits" />
							<xsl:with-param name="loss-cost" select="$vehiclePremium/ExtraordinaryMedicalBenefitsLossCost" />
							<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
							<xsl:with-param name="premium" select="$vehiclePremium/ExtraordinaryMedicalBenefitsPremium" />
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				<xsl:if test="VehicleDescrCheckCoveragesAdditionalNoFaultProtection = 'True'">
					<xsl:call-template name="vehicle-premiums-breakdown">
						<xsl:with-param name="coverage" select="'Additional PIP'" />
						<xsl:with-param name="limit">
							<xsl:choose >
								<xsl:when test="$location-state = 'NJ'">
										<xsl:value-of select="//Business/AdditionalPIP"/>
								</xsl:when>
								<xsl:when test="$location-state = 'FL'">
									<xsl:value-of select="//Business/AdditionalPIPFL"/>
								</xsl:when>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="loss-cost" select="$vehiclePremium/AdditionalPIPLossCost" />
						<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
						<xsl:with-param name="premium" select="$vehiclePremium/AdditionalPIPPremium" />
						<xsl:with-param name="is-string" select="$location-state = 'NJ'" />
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
		</table>
		<table class="vehicles-table">
			<xsl:if test="VehicleDescrCheckCoveragesMedicalPayments = 'True'">
				<tr>
					<th></th>
					<th class="txt_center">Limit</th>
					<th class="txt_center">LC</th>
					<th class="txt_center">LCM</th>
					<th></th>
					<th class="txt_center">Class</th>
					<th></th>
					<th class="txt_center">Zone</th>
					<th></th>
					<th></th>
					<th></th>
					<th class="txt_right">Premium</th>
				</tr>
				<xsl:call-template name="vehicle-premiums-breakdown">
					<xsl:with-param name="coverage" select="'Medical Payments'" />
					<xsl:with-param name="limit" select="//BusinessAuto/MedicalPaymentsPerPersonLimit" />
					<xsl:with-param name="loss-cost" select="$vehiclePremium/MedPayLossCost" />
					<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
					<xsl:with-param name="class" select="$vehiclePremium/MedPayClassFactor" />
					<xsl:with-param name="additional-factor-1" select="$vehiclePremium/MedPayZoneFactor" />
					<xsl:with-param name="premium" select="$vehiclePremium/MedPayPremium" />
				</xsl:call-template>
			</xsl:if>
		</table>
		<table class="vehicles-table">
			<xsl:if test="VehicleDescrCheckCoveragesUninsuredMotorist = 'True'">
				<xsl:call-template name="vehicle-premiums-breakdown">
					<xsl:with-param name="coverage" select="'UM'" />
					<xsl:with-param name="limit" select="//BusinessAuto/UninsuredMotoristsLimitsCSLAmount" />
					<xsl:with-param name="loss-cost" select="$vehiclePremium/UninsuredMotoristLossCost" />
					<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
					<xsl:with-param name="premium" select="$vehiclePremium/UninsuredMotoristPremium" />
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="//BusinessAuto/UninsuredMotoristsLimitsPropertyDamageRequested = 'True'and ($location-state = 'CA' or $location-state = 'TX')">
				<xsl:call-template name="vehicle-premiums-breakdown">
					<xsl:with-param name="coverage" select="'UM PD'" />
					<xsl:with-param name="limit">
						<xsl:choose>
							<xsl:when test="$location-state = 'CA'">3500</xsl:when>
							<xsl:when test="$location-state = 'TX'">
								<xsl:value-of select="//BusinessAuto/UninsuredMotoristsLimitsPropertyDamage"/>
							</xsl:when>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="loss-cost" select="$vehiclePremium/UMPDLossCost" />
					<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
					<xsl:with-param name="premium" select="$vehiclePremium/UMPDPremium" />
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="VehicleDescrCheckCoveragesUnderinsuredMotorist = 'True'">
				<xsl:call-template name="vehicle-premiums-breakdown">
					<xsl:with-param name="coverage" select="'UIM'" />
					<xsl:with-param name="limit" select="//BusinessAuto/UnderinsuredMotoristsLimitsCSLAmount" />
					<xsl:with-param name="loss-cost" select="$vehiclePremium/UnderinsuredMotoristLossCost" />
					<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/LiabilityLossCostMultiplier" />
					<xsl:with-param name="premium" select="$vehiclePremium/UnderinsuredMotoristPremium" />
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="VehicleDescrCheckCoveragesTowingAndLabor = 'True'">
				<xsl:call-template name="vehicle-premiums-breakdown">
					<xsl:with-param name="coverage" select="'Towing &amp; Labor'" />
					<xsl:with-param name="limit" select="//BusinessAuto/PhysicalDamageTowingLaborLimits" />
					<xsl:with-param name="loss-cost" select="$vehiclePremium/TowingAndLaborLossCost" />
					<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/PhysicalDamageLossCostMultiplier" />
					<xsl:with-param name="experience-rate" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageExperienceRatingModificationFactor" />
					<xsl:with-param name="premium" select="$vehiclePremium/TowingAndLabor" />
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="//Business/AudioVisual = 'True'">
				<xsl:call-template name="vehicle-premiums-breakdown">
					<xsl:with-param name="coverage" select="'Audio &amp; Visual'" />
					<xsl:with-param name="limit" select="//Business/AudioVisualPerLossLimit" />
					<xsl:with-param name="loss-cost" select="$vehiclePremium/AudioVisualLossCost" />
					<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/PhysicalDamageLossCostMultiplier" />
					<xsl:with-param name="experience-rate" select="//Proposal/Rating/EperienceRatingTable/PhysicalDamageExperienceRatingModificationFactor" />
					<xsl:with-param name="premium" select="$vehiclePremium/AudioVisualPremium" />
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="VehicleDescrCheckCoveragesRentalReimbursementCoverage = 'True'">
				<xsl:call-template name="vehicle-premiums-breakdown">
					<xsl:with-param name="coverage" select="'Rental Reimbursement'" />
					<xsl:with-param name="loss-cost" select="$vehiclePremium/RentalReimbursementLossCost" />
					<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/PhysicalDamageLossCostMultiplier" />
					<xsl:with-param name="premium" select="$vehiclePremium/RentalReimbursementPremium" />
				</xsl:call-template>
			</xsl:if>
		</table>
		<xsl:if test="VehicleDescrCheckCoveragesComprehensiveCoverage = 'True' or VehicleDescrCheckCoveragesCollisionCoverage = 'True'">
			<table class="vehicles-table">
				<tr>
					<th></th>
					<th class="txt_center">Deductible</th>
					<th class="txt_center">LC</th>
					<th class="txt_center">LCM</th>
					<th></th>
					<th class="txt_center">Class</th>
					<th class="txt_center">Fleet</th>
					<th class="txt_center">
						<xsl:choose >
							<xsl:when test="$vehiclePremium/OptionalClassPlan = 'True'">Value</xsl:when>
							<xsl:otherwise>Cost</xsl:otherwise>
						</xsl:choose>
					</th>
					<th class="txt_center">Deduct</th>
					<th class="txt_center">
						<xsl:choose >
							<xsl:when test="$vehiclePremium/OptionalClassPlan = 'True'">NAICS</xsl:when>
							<xsl:otherwise>Age</xsl:otherwise>
						</xsl:choose>
					</th>
					<th class="txt_center">ER</th>
					<th class="txt_right">Premium</th>
				</tr>
				<xsl:if test="VehicleDescrCheckCoveragesComprehensiveCoverage = 'True'">
					<xsl:call-template name="vehicle-premiums-breakdown">
						<xsl:with-param name="coverage">
							<xsl:choose >
								 <xsl:when test="$location-state = 'CA'">Comprehensive</xsl:when>
								 <xsl:otherwise>All Perils-Glass</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="limit" select="VehicleDescrOtherThanCollisionDeductible" />
						<xsl:with-param name="loss-cost" select="$vehiclePremium/OTCLossCost" />
						<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/PhysicalDamageLossCostMultiplier" />
						<xsl:with-param name="class-factor" select="$vehiclePremium/OTCClassFactor" />
						<xsl:with-param name="fleet-factor" select="$vehiclePremium/OTCFleetFactor" />
						<xsl:with-param name="additional-factor-1">
							<xsl:choose >
								<xsl:when test="$vehiclePremium/OptionalClassPlan = 'True'">
									<xsl:value-of select="$vehiclePremium/OTCValueFactor" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$vehiclePremium/OTCCostFactor" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="additional-factor-2" select="$vehiclePremium/OTCDeductibleFactor" />
						<xsl:with-param name="additional-factor-3">
							<xsl:choose >
								<xsl:when test="$vehiclePremium/OptionalClassPlan = 'True'">
									<xsl:value-of select="$vehiclePremium/OTCNAICSFactor" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$vehiclePremium/OTCAgeFactor" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="experience-rate" select="$vehiclePremium/OTCModificationFactor" />
						<xsl:with-param name="premium" select="$vehiclePremium/OTCPremium" />
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="VehicleDescrCheckCoveragesCollisionCoverage = 'True'">
					<xsl:call-template name="vehicle-premiums-breakdown">
						<xsl:with-param name="coverage" select="'Collision'" />
						<xsl:with-param name="limit" select="VehicleDescrCollisionDeductible" />
						<xsl:with-param name="loss-cost" select="$vehiclePremium/CollisionLossCost" />
						<xsl:with-param name="loss-cost-multiplier" select="$vehiclePremium/PhysicalDamageLossCostMultiplier" />
						<xsl:with-param name="class-factor" select="$vehiclePremium/CollisionClassFactor" />
						<xsl:with-param name="fleet-factor" select="$vehiclePremium/CollisionFleetFactor" />
						<xsl:with-param name="additional-factor-1">
							<xsl:choose >
								<xsl:when test="$vehiclePremium/OptionalClassPlan = 'True'">
									<xsl:value-of select="$vehiclePremium/CollisionValueFactor" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$vehiclePremium/CollisionCostFactor" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>			
						<xsl:with-param name="additional-factor-2" select="$vehiclePremium/CollisionDeductibleFactor" />
						<xsl:with-param name="additional-factor-3">
							<xsl:choose >
								<xsl:when test="$vehiclePremium/OptionalClassPlan = 'True'">
									<xsl:value-of select="$vehiclePremium/CollisionNAICSFactor" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$vehiclePremium/CollisionAgeFactor" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="experience-rate" select="$vehiclePremium/CollisionModificationFactor" />
						<xsl:with-param name="premium" select="$vehiclePremium/CollisionPremium" />	
					</xsl:call-template>	
				</xsl:if>	
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template name="printDate">
		<xsl:param name="date"/>
		<xsl:variable name="month">
			<xsl:choose>
				<xsl:when test="$date/Month = '1'">January</xsl:when>
				<xsl:when test="$date/Month = '2'">February</xsl:when>
				<xsl:when test="$date/Month = '3'">March</xsl:when>
				<xsl:when test="$date/Month = '4'">April</xsl:when>
				<xsl:when test="$date/Month = '5'">May</xsl:when>
				<xsl:when test="$date/Month = '6'">June</xsl:when>
				<xsl:when test="$date/Month = '7'">July</xsl:when>
				<xsl:when test="$date/Month = '8'">August</xsl:when>
				<xsl:when test="$date/Month = '9'">September</xsl:when>
				<xsl:when test="$date/Month = '10'">October</xsl:when>
				<xsl:when test="$date/Month = '11'">November</xsl:when>
				<xsl:when test="$date/Month = '12'">December</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="day" select="$date/Day"/>
		<xsl:variable name="year" select="$date/Year"/>
		<xsl:value-of select="$month"/>&#160;<xsl:value-of select="$day"/>,
		<xsl:value-of select="$year"/>
	</xsl:template>

</xsl:stylesheet>