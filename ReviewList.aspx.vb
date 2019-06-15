Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.Configuration

Public Class ReviewList
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
    Public Const ADMIN As Integer = 1
    Public Const AUDITOR_ID As Integer = 2
    Public Const HOUSING_SPECALIST As Integer = 3

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim sessionUserID As String = GetSessionUserID()
        Dim sessionUserRoleID As Integer = GetUserRoleID(sessionUserID)

        If sessionUserRoleID = HOUSING_SPECALIST Then
            DisplayListingsBasedOnHousingSpecialist(sessionUserID)
        End If

        If Not IsPostBack Then
            SetFiltersToAll()
        End If
    End Sub

    Private Sub BindGridWithFilters()
        Dim sessionUserID As String = GetSessionUserID()
        Dim sessionUserRoleID As Integer = GetUserRoleID(sessionUserID)

        Select Case sessionUserRoleID
            Case ADMIN To AUDITOR_ID
                Dim sql As String = "SELECT FileID, ClientFirstName + ' ' + ClientLastName AS Client, EliteID, " & _
                         "       fk_CaseManagerID AS FileStaffID, " & _
                         "       FileStaff.FirstName + ' ' + FileStaff.LastName AS FileStaffName, " & _
                         "       GroupID, Groups.[Group], fk_ReviewTypeID, ReviewTypes.Review, " & _
                         "       CONVERT(varchar(max), cast([ReviewDate] as date), 101) As ReviewDate, " & _
                         "       CONVERT(varchar(max), cast([EffectiveDate] as date), 101) As EffectiveDate, " & _
                         "       Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, " & _
                         "       TotalErrors = ((SELECT COUNT(fk_FileID) " & _
                         "                       FROM FileErrors " & _
                         "                       WHERE FileErrors.fk_FileID = Files.FileID) + " & _
                         "						(SELECT COUNT(fk_FileID)   " & _
                         "                        FROM LotteryNumberErrors " & _
                         "						 WHERE LotteryNumberErrors.fk_FileID =  Files.FileID) + " & _
                         "				        (SELECT COUNT(fk_FileID) " & _
                         "                        FROM SpecialCaseErrors " & _
                         "						 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '19') + " & _
                         "                       (SELECT COUNT(fk_FileID) " & _
                         "                        FROM SpecialCaseErrors " & _
                         "						 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '20')), " & _
                         "       Verification = (SELECT COUNT(fk_FileID) " & _
                         "                       FROM FileErrors " & _
                         "                       WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '1'), " & _
                         "       Calculation = (SELECT COUNT(fk_FileID) " & _
                         "                      FROM FileErrors " & _
                         "	                   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '2'), " & _
                         "       PaymentStandard = (SELECT COUNT(fk_FileID) " & _
                         "                          FROM FileErrors " & _
                         "						   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '3'), " & _
                         "       UtilityAllowance = (SELECT COUNT(fk_FileID) " & _
                         "                           FROM FileErrors " & _
                         "                           WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '4'),	 " & _
                         "       TenantRent   = (SELECT COUNT(fk_FileID) " & _
                         "                       FROM FileErrors " & _
                         "                       WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '5'), " & _
                         "       OccupanyStandard   = (SELECT COUNT(fk_FileID)  " & _
                         "                            FROM FileErrors " & _
                         "	                         WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '6'),	" & _
                         "       AnnualReexamination   = (SELECT COUNT(fk_FileID) " & _
                         "                               FROM FileErrors " & _
                         "	                            WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '7'), " & _
                         "       InterimReexamination   = (SELECT COUNT(fk_FileID) " & _
                         "                                 FROM FileErrors " & _
                         "                                  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '8'),	" & _
                         "        Moves		     = (SELECT COUNT(fk_FileID) " & _
                         "                           FROM FileErrors " & _
                         "                           WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '9'), " & _
                         "       ChangeInFamilyComposition  = (SELECT COUNT(fk_FileID) " & _
                         "                                     FROM FileErrors " & _
                         "                                  	  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '10'), " & _
                         "       EligibilityAndScreening  = (SELECT COUNT(fk_FileID)  " & _
                         "                                   FROM FileErrors " & _
                         "	                                WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '11'), " & _
                         "       Leasing  = (SELECT COUNT(fk_FileID) " & _
                         "                  FROM FileErrors " & _
                         "                  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '12'), " & _
                         "       DataEntry =  (SELECT COUNT(fk_FileID) " & _
                         "                     FROM FileErrors " & _
                         "                     WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '13'), " & _
                         "       LotteryNumber =   (SELECT COUNT(fk_FileID) " & _
                         "                          FROM LotteryNumberErrors " & _
                         "                          WHERE LotteryNumberErrors.fk_FileID =  Files.FileID), " & _
                         "       ReasonableRent = (SELECT COUNT(fk_FileID) " & _
                         "                         FROM FileErrors " & _
                         "	                      WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '15'), " & _
                         "       Portability =  (SELECT COUNT(fk_FileID) " & _
                         "                       FROM FileErrors  " & _
                         "	                    WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '16'), " & _
                         "       OwnerCertification = (SELECT COUNT(fk_FileID) " & _
                         "                               FROM FileErrors  " & _
                         "                               WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '17'), " & _
                         "       Document = (SELECT COUNT(fk_FileID) " & _
                         "                   FROM FileErrors " & _
                         "	                WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '18'), " & _
                         "       SpecialAdmission =  (SELECT COUNT(fk_FileID) " & _
                         "                            FROM SpecialCaseErrors " & _
                         "	                         WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '19'), " & _
                         "       PortIn = (SELECT COUNT(fk_FileID) " & _
                         "                 FROM SpecialCaseErrors " & _
                         "                 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '20'), " & _
                         "       Other =	(SELECT COUNT(fk_FileID) " & _
                         "               FROM FileErrors  " & _
                         "	            WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '21'), " & _
                         "       SelectionFromTheWaitlist = (SELECT COUNT(fk_FileID) " & _
                         "                                   FROM FileErrors " & _
                         "                                   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '22') " & _
                         "FROM Files " & _
                         "INNER JOIN Users As FileStaff ON Files.fk_CaseManagerID = FileStaff.UserID " & _
                         "INNER JOIN ReviewTypes ON Files.fk_ReviewTypeID = ReviewTypes.ReviewTypeID " & _
                         "INNER JOIN Users As Auditor ON Files.fk_AudtitorID = Auditor.UserID " & _
                         "INNER JOIN Groups ON FileStaff.fk_GroupID = Groups.GroupID " & _
                         "WHERE Files.FileID != '0'"

                Dim firstName As String = ClientFirstName.Text
                Dim lastname As String = ClientLastName.Text
                Dim clientID As String = EliteID.Text
                Dim fileStaffID As Integer = FileStaff.SelectedValue
                Dim auditorID As Integer = Auditor.SelectedValue
                Dim groupID As Integer = Group.SelectedValue
                Dim reviewTypeID As Integer = ReviewType.SelectedValue
                Dim reviewDateBeginUnconverted As String = ReviewDateBegin.Text
                Dim reviewDateEndUnconverted As String = ReviewDateEnd.Text

                If Not String.IsNullOrEmpty(firstName) Then
                    sql += " AND Files.ClientFirstName LIKE '" + firstName.ToString() + "%'"
                End If

                If Not String.IsNullOrEmpty(lastname) Then
                    sql += " AND Files.ClientLastName LIKE '" + lastname.ToString() + "%'"
                End If

                If Not String.IsNullOrEmpty(clientID) Then
                    sql += " AND Files.EliteID LIKE '" + clientID.ToString() + "%'"
                End If

                If (fileStaffID > 0) Then
                    sql += " AND Files.fk_CaseManagerID = " + fileStaffID.ToString()
                End If

                If (auditorID > 0) Then
                    sql += " AND Auditor.UserID = " + auditorID.ToString()
                End If

                If (groupID > 0) Then
                    sql += " AND Groups.GroupID = " + groupID.ToString()
                End If

                If (reviewTypeID > 0) Then
                    sql += " AND ReviewTypes.ReviewTypeID = " + reviewTypeID.ToString()
                End If

                If Not String.IsNullOrEmpty(reviewDateBeginUnconverted) And Not String.IsNullOrEmpty(reviewDateEndUnconverted) Then
                    Dim reviewDateBeginConverted As String = ConvertStringFormatDatetoSqlDate(reviewDateBeginUnconverted)
                    Dim reviewDateEndConverted As String = ConvertStringFormatDatetoSqlDate(reviewDateEndUnconverted)

                    sql += " AND ReviewDate BETWEEN '" + reviewDateBeginConverted + "' AND '" + reviewDateEndConverted + "' "
                End If

                SqlDataSource1.SelectCommand = sql
                SqlDataSource1.DataBind()
                GridView1.DataBind()


            Case HOUSING_SPECALIST
                Dim sql As String = "SELECT FileID, ClientFirstName + ' ' + ClientLastName AS Client, EliteID, " & _
                   "       fk_CaseManagerID AS FileStaffID, " & _
                   "       FileStaff.FirstName + ' ' + FileStaff.LastName AS FileStaffName, " & _
                   "       GroupID, Groups.[Group], fk_ReviewTypeID, ReviewTypes.Review, " & _
                   "       CONVERT(varchar(max), cast([ReviewDate] as date), 101) As ReviewDate, " & _
                   "       CONVERT(varchar(max), cast([EffectiveDate] as date), 101) As EffectiveDate, " & _
                   "       Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, " & _
                   "       TotalErrors = ((SELECT COUNT(fk_FileID) " & _
                   "                       FROM FileErrors " & _
                   "                       WHERE FileErrors.fk_FileID = Files.FileID) + " & _
                   "						(SELECT COUNT(fk_FileID)   " & _
                   "                        FROM LotteryNumberErrors " & _
                   "						 WHERE LotteryNumberErrors.fk_FileID =  Files.FileID) + " & _
                   "				        (SELECT COUNT(fk_FileID) " & _
                   "                        FROM SpecialCaseErrors " & _
                   "						 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '19') + " & _
                   "                       (SELECT COUNT(fk_FileID) " & _
                   "                        FROM SpecialCaseErrors " & _
                   "						 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '20')), " & _
                   "       Verification = (SELECT COUNT(fk_FileID) " & _
                   "                       FROM FileErrors " & _
                   "                       WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '1'), " & _
                   "       Calculation = (SELECT COUNT(fk_FileID) " & _
                   "                      FROM FileErrors " & _
                   "	                   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '2'), " & _
                   "       PaymentStandard = (SELECT COUNT(fk_FileID) " & _
                   "                          FROM FileErrors " & _
                   "						   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '3'), " & _
                   "       UtilityAllowance = (SELECT COUNT(fk_FileID) " & _
                   "                           FROM FileErrors " & _
                   "                           WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '4'),	 " & _
                   "       TenantRent   = (SELECT COUNT(fk_FileID) " & _
                   "                       FROM FileErrors " & _
                   "                       WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '5'), " & _
                   "       OccupanyStandard   = (SELECT COUNT(fk_FileID)  " & _
                   "                            FROM FileErrors " & _
                   "	                         WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '6'),	" & _
                   "       AnnualReexamination   = (SELECT COUNT(fk_FileID) " & _
                   "                               FROM FileErrors " & _
                   "	                            WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '7'), " & _
                   "       InterimReexamination   = (SELECT COUNT(fk_FileID) " & _
                   "                                 FROM FileErrors " & _
                   "                                  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '8'),	" & _
                   "        Moves		     = (SELECT COUNT(fk_FileID) " & _
                   "                           FROM FileErrors " & _
                   "                           WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '9'), " & _
                   "       ChangeInFamilyComposition  = (SELECT COUNT(fk_FileID) " & _
                   "                                     FROM FileErrors " & _
                   "                                  	  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '10'), " & _
                   "       EligibilityAndScreening  = (SELECT COUNT(fk_FileID)  " & _
                   "                                   FROM FileErrors " & _
                   "	                                WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '11'), " & _
                   "       Leasing  = (SELECT COUNT(fk_FileID) " & _
                   "                  FROM FileErrors " & _
                   "                  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '12'), " & _
                   "       DataEntry =  (SELECT COUNT(fk_FileID) " & _
                   "                     FROM FileErrors " & _
                   "                     WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '13'), " & _
                   "       LotteryNumber =   (SELECT COUNT(fk_FileID) " & _
                   "                          FROM LotteryNumberErrors " & _
                   "                          WHERE LotteryNumberErrors.fk_FileID =  Files.FileID), " & _
                   "       ReasonableRent = (SELECT COUNT(fk_FileID) " & _
                   "                         FROM FileErrors " & _
                   "	                      WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '15'), " & _
                   "       Portability =  (SELECT COUNT(fk_FileID) " & _
                   "                       FROM FileErrors  " & _
                   "	                    WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '16'), " & _
                   "       OwnerCertification = (SELECT COUNT(fk_FileID) " & _
                   "                               FROM FileErrors  " & _
                   "                               WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '17'), " & _
                   "       Document = (SELECT COUNT(fk_FileID) " & _
                   "                   FROM FileErrors " & _
                   "	                WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '18'), " & _
                   "       SpecialAdmission =  (SELECT COUNT(fk_FileID) " & _
                   "                            FROM SpecialCaseErrors " & _
                   "	                         WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '19'), " & _
                   "       PortIn = (SELECT COUNT(fk_FileID) " & _
                   "                 FROM SpecialCaseErrors " & _
                   "                 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '20'), " & _
                   "       Other =	(SELECT COUNT(fk_FileID) " & _
                   "               FROM FileErrors  " & _
                   "	            WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '21'), " & _
                   "       SelectionFromTheWaitlist = (SELECT COUNT(fk_FileID) " & _
                   "                                   FROM FileErrors " & _
                   "                                   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '22') " & _
                   "FROM Files " & _
                   "INNER JOIN Users As FileStaff ON Files.fk_CaseManagerID = FileStaff.UserID " & _
                   "INNER JOIN ReviewTypes ON Files.fk_ReviewTypeID = ReviewTypes.ReviewTypeID " & _
                   "INNER JOIN Users As Auditor ON Files.fk_AudtitorID = Auditor.UserID " & _
                   "INNER JOIN Groups ON FileStaff.fk_GroupID = Groups.GroupID " & _
                   "WHERE FileStaff.UserID = '" & sessionUserID & "'"


                Dim firstName As String = ClientFirstName.Text
                Dim lastname As String = ClientLastName.Text
                Dim clientID As String = EliteID.Text
                Dim reviewTypeID As String = ReviewType.SelectedValue
                Dim reviewDateBeginUnconverted As String = ReviewDateBegin.Text
                Dim reviewDateEndUnconverted As String = ReviewDateEnd.Text

                If Not String.IsNullOrEmpty(firstName) Then
                    sql += " AND Files.ClientFirstName LIKE '" + firstName.ToString() + "%'"
                End If

                If Not String.IsNullOrEmpty(lastname) Then
                    sql += " AND Files.ClientLastName LIKE '" + lastname.ToString() + "%'"
                End If

                If Not String.IsNullOrEmpty(clientID) Then
                    sql += " AND Files.EliteID LIKE '" + clientID.ToString() + "%'"
                End If

                If (reviewTypeID > 0) Then
                    sql += " AND ReviewTypes.ReviewTypeID = '" + reviewTypeID + "'"
                End If

                If Not String.IsNullOrEmpty(reviewDateBeginUnconverted) And Not String.IsNullOrEmpty(reviewDateEndUnconverted) Then
                    Dim reviewDateBeginConverted As String = ConvertStringFormatDatetoSqlDate(reviewDateBeginUnconverted)
                    Dim reviewDateEndConverted As String = ConvertStringFormatDatetoSqlDate(reviewDateEndUnconverted)

                    sql += " AND ReviewDate BETWEEN '" + reviewDateBeginConverted + "' AND '" + reviewDateEndConverted + "' "
                End If

                SqlDataSource1.SelectCommand = sql
                SqlDataSource1.DataBind()
                GridView1.DataBind()
        End Select
    End Sub

    Private Function ConvertStringFormatDatetoSqlDate(ByVal dateToConvert As String) As String
        Dim dateParsedArray() As String = ParseDate(dateToConvert)
        Dim month As Integer = Integer.Parse(dateParsedArray(0))
        Dim day As String = dateParsedArray(1)
        Dim year As String = dateParsedArray(2)
        Dim monthAbbrevName As String = MonthName(month, True)

        day = " " + day.Trim()
        year = " " + year.Trim()

        Return String.Concat(monthAbbrevName, day, year)
    End Function

    Public Function DisplayClientNameLink(ByVal reviewTypeID As Integer, ByVal clientName As String, ByVal fileID As Integer, ByVal sessionUserID As Integer) As String
        Const ANNUAL_REEXAMINATION As Integer = 1
        Const ELIGIBILITY_SCREENING As Integer = 2
        Const INTERIM_REEXAMINATION As Integer = 3
        Const MOVES As Integer = 4
        Const PORT_IN As Integer = 5
        Const REASONABLE_RENT As Integer = 6
        Const SELECTION_FROM_WAITLIST As Integer = 7
        Const LEASING As Integer = 8

        Dim link As String = ""

        Select Case reviewTypeID
            Case ANNUAL_REEXAMINATION
                link = "<a href=CreateAnnualReexamination.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case ELIGIBILITY_SCREENING
                link = "<a href=CreateEligibilityScreening.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case INTERIM_REEXAMINATION
                link = "<a href=CreateInterimReexamination.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case MOVES
                link = "<a href=CreateMoves.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case PORT_IN
                link = "<a href=CreatePortIn.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case REASONABLE_RENT
                link = "<a href=CreateReasonableRent.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case SELECTION_FROM_WAITLIST
                link = "<a href=CreateSelectionFromWaitlist.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case LEASING
                link = "<a href=CreateLeasing.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
        End Select

        Return link
    End Function

    Public Function DisplayFileLink(ByVal reviewTypeID As Integer, ByVal clientName As String, ByVal fileID As Integer, ByVal sessionUserID As Integer) As String
        Dim link As String = ""

        Dim roleID As Integer = GetUserRoleID(sessionUserID)
        Select Case roleID
            Case ADMIN
                link = DisplayClientNameLink(reviewTypeID, clientName, fileID, sessionUserID)
            Case AUDITOR_ID
                Dim auditorID As Integer = GetAuditorIDForFile(fileID)

                If sessionUserID = auditorID Then
                    link = DisplayClientNameLink(reviewTypeID, clientName, fileID, sessionUserID)
                Else
                    link = clientName
                End If

            Case HOUSING_SPECALIST
                link = clientName
        End Select

        Return link
    End Function

    Public Sub DisplayListingsForAdminOrAuditor()
        Dim sql As String = "SELECT FileID, ClientFirstName + ' ' + ClientLastName AS Client, EliteID, " & _
                            "       fk_CaseManagerID AS FileStaffID, " & _
                            "       FileStaff.FirstName + ' ' + FileStaff.LastName AS FileStaffName, " & _
                            "       GroupID, Groups.[Group], fk_ReviewTypeID, ReviewTypes.Review, " & _
                            "       CONVERT(varchar(max), cast([ReviewDate] as date), 101) As ReviewDate, " & _
                            "       CONVERT(varchar(max), cast([EffectiveDate] as date), 101) As EffectiveDate, " & _
                            "       Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, " & _
                            "       TotalErrors = ((SELECT COUNT(fk_FileID) " & _
                            "                       FROM FileErrors " & _
                            "                       WHERE FileErrors.fk_FileID = Files.FileID) + " & _
                            "						(SELECT COUNT(fk_FileID)   " & _
                            "                        FROM LotteryNumberErrors " & _
                            "						 WHERE LotteryNumberErrors.fk_FileID =  Files.FileID) + " & _
                            "				        (SELECT COUNT(fk_FileID) " & _
                            "                        FROM SpecialCaseErrors " & _
                            "						 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '19') + " & _
                            "                       (SELECT COUNT(fk_FileID) " & _
                            "                        FROM SpecialCaseErrors " & _
                            "						 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '20')), " & _
                            "       Verification = (SELECT COUNT(fk_FileID) " & _
                            "                       FROM FileErrors " & _
                            "                       WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '1'), " & _
                            "       Calculation = (SELECT COUNT(fk_FileID) " & _
                            "                      FROM FileErrors " & _
                            "	                   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '2'), " & _
                            "       PaymentStandard = (SELECT COUNT(fk_FileID) " & _
                            "                          FROM FileErrors " & _
                            "						   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '3'), " & _
                            "       UtilityAllowance = (SELECT COUNT(fk_FileID) " & _
                            "                           FROM FileErrors " & _
                            "                           WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '4'),	 " & _
                            "       TenantRent   = (SELECT COUNT(fk_FileID) " & _
                            "                       FROM FileErrors " & _
                            "                       WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '5'), " & _
                            "       OccupanyStandard   = (SELECT COUNT(fk_FileID)  " & _
                            "                            FROM FileErrors " & _
                            "	                         WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '6'),	" & _
                            "       AnnualReexamination   = (SELECT COUNT(fk_FileID) " & _
                            "                               FROM FileErrors " & _
                            "	                            WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '7'), " & _
                            "       InterimReexamination   = (SELECT COUNT(fk_FileID) " & _
                            "                                 FROM FileErrors " & _
                            "                                  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '8'),	" & _
                            "        Moves		     = (SELECT COUNT(fk_FileID) " & _
                            "                           FROM FileErrors " & _
                            "                           WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '9'), " & _
                            "       ChangeInFamilyComposition  = (SELECT COUNT(fk_FileID) " & _
                            "                                     FROM FileErrors " & _
                            "                                  	  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '10'), " & _
                            "       EligibilityAndScreening  = (SELECT COUNT(fk_FileID)  " & _
                            "                                   FROM FileErrors " & _
                            "	                                WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '11'), " & _
                            "       Leasing  = (SELECT COUNT(fk_FileID) " & _
                            "                  FROM FileErrors " & _
                            "                  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '12'), " & _
                            "       DataEntry =  (SELECT COUNT(fk_FileID) " & _
                            "                     FROM FileErrors " & _
                            "                     WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '13'), " & _
                            "       LotteryNumber =   (SELECT COUNT(fk_FileID) " & _
                            "                          FROM LotteryNumberErrors " & _
                            "                          WHERE LotteryNumberErrors.fk_FileID =  Files.FileID), " & _
                            "       ReasonableRent = (SELECT COUNT(fk_FileID) " & _
                            "                         FROM FileErrors " & _
                            "	                      WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '15'), " & _
                            "       Portability =  (SELECT COUNT(fk_FileID) " & _
                            "                       FROM FileErrors  " & _
                            "	                    WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '16'), " & _
                            "       OwnerCertification = (SELECT COUNT(fk_FileID) " & _
                            "                               FROM FileErrors  " & _
                            "                               WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '17'), " & _
                            "       Document = (SELECT COUNT(fk_FileID) " & _
                            "                   FROM FileErrors " & _
                            "	                WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '18'), " & _
                            "       SpecialAdmission =  (SELECT COUNT(fk_FileID) " & _
                            "                            FROM SpecialCaseErrors " & _
                            "	                         WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '19'), " & _
                            "       PortIn = (SELECT COUNT(fk_FileID) " & _
                            "                 FROM SpecialCaseErrors " & _
                            "                 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '20'), " & _
                            "       Other =	(SELECT COUNT(fk_FileID) " & _
                            "               FROM FileErrors  " & _
                            "	            WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '21'), " & _
                            "       SelectionFromTheWaitlist = (SELECT COUNT(fk_FileID) " & _
                            "                                   FROM FileErrors " & _
                            "                                   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '22') " & _
                            "FROM Files " & _
                            "INNER JOIN Users As FileStaff ON Files.fk_CaseManagerID = FileStaff.UserID " & _
                            "INNER JOIN ReviewTypes ON Files.fk_ReviewTypeID = ReviewTypes.ReviewTypeID " & _
                            "INNER JOIN Users As Auditor ON Files.fk_AudtitorID = Auditor.UserID " & _
                            "INNER JOIN Groups ON FileStaff.fk_GroupID = Groups.GroupID " & _
                            "WHERE Files.FileID != '0'"

        Dim firstName As String = ClientFirstName.Text
        Dim lastname As String = ClientLastName.Text
        Dim _eliteID As String = EliteID.Text
        Dim fileStaffID As Integer = FileStaff.SelectedValue
        Dim auditorID As Integer = Auditor.SelectedValue
        Dim groupID As Integer = Group.SelectedValue
        Dim reviewTypeID As Integer = ReviewType.SelectedValue
        Dim reviewDateBeginUnconverted As String = ReviewDateBegin.Text
        Dim reviewDateEndUnconverted As String = ReviewDateEnd.Text


        If Not String.IsNullOrEmpty(firstName) Then
            sql += " AND Files.ClientFirstName LIKE '" + firstName.ToString() + "%'"
        End If

        If Not String.IsNullOrEmpty(lastname) Then
            sql += " AND Files.ClientLastName LIKE '" + lastname.ToString() + "%'"
        End If

        If Not String.IsNullOrEmpty(_eliteID) Then
            sql += " AND Files.EliteID LIKE '" + _eliteID.ToString() + "%'"
        End If

        If (fileStaffID > 0) Then
            sql += " AND Files.fk_CaseManagerID = " + fileStaffID.ToString()
        End If

        If (auditorID > 0) Then
            sql += " AND Auditor.UserID = " + auditorID.ToString()
        End If

        If (groupID > 0) Then
            sql += " AND Groups.GroupID = " + groupID.ToString()
        End If

        If (reviewTypeID > 0) Then
            sql += " AND ReviewTypes.ReviewTypeID = " + reviewTypeID.ToString()
        End If

        If Not String.IsNullOrEmpty(reviewDateBeginUnconverted) And Not String.IsNullOrEmpty(reviewDateEndUnconverted) Then
            Dim reviewDateBeginConverted As String = ConvertStringFormatDatetoSqlDate(reviewDateBeginUnconverted)
            Dim reviewDateEndConverted As String = ConvertStringFormatDatetoSqlDate(reviewDateEndUnconverted)

            sql += " AND ReviewDate BETWEEN '" + reviewDateBeginConverted + "' AND '" + reviewDateEndConverted + "' "
        End If


        SqlDataSource1.SelectCommand = sql
        SqlDataSource1.DataBind()
        GridView1.DataBind()
    End Sub

    Public Sub DisplayListingsBasedOnHousingSpecialist(ByVal userID As Integer)
        Dim sql As String = "SELECT FileID, ClientFirstName + ' ' + ClientLastName AS Client, EliteID, " & _
                    "       fk_CaseManagerID AS FileStaffID, " & _
                    "       FileStaff.FirstName + ' ' + FileStaff.LastName AS FileStaffName, " & _
                    "       GroupID, Groups.[Group], fk_ReviewTypeID, ReviewTypes.Review, " & _
                    "       CONVERT(varchar(max), cast([ReviewDate] as date), 101) As ReviewDate, " & _
                    "       CONVERT(varchar(max), cast([EffectiveDate] as date), 101) As EffectiveDate, " & _
                    "       Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, " & _
                    "       TotalErrors = ((SELECT COUNT(fk_FileID) " & _
                    "                       FROM FileErrors " & _
                    "                       WHERE FileErrors.fk_FileID = Files.FileID) + " & _
                    "						(SELECT COUNT(fk_FileID)   " & _
                    "                        FROM LotteryNumberErrors " & _
                    "						 WHERE LotteryNumberErrors.fk_FileID =  Files.FileID) + " & _
                    "				        (SELECT COUNT(fk_FileID) " & _
                    "                        FROM SpecialCaseErrors " & _
                    "						 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '19') + " & _
                    "                       (SELECT COUNT(fk_FileID) " & _
                    "                        FROM SpecialCaseErrors " & _
                    "						 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '20')), " & _
                    "       Verification = (SELECT COUNT(fk_FileID) " & _
                    "                       FROM FileErrors " & _
                    "                       WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '1'), " & _
                    "       Calculation = (SELECT COUNT(fk_FileID) " & _
                    "                      FROM FileErrors " & _
                    "	                   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '2'), " & _
                    "       PaymentStandard = (SELECT COUNT(fk_FileID) " & _
                    "                          FROM FileErrors " & _
                    "						   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '3'), " & _
                    "       UtilityAllowance = (SELECT COUNT(fk_FileID) " & _
                    "                           FROM FileErrors " & _
                    "                           WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '4'),	 " & _
                    "       TenantRent   = (SELECT COUNT(fk_FileID) " & _
                    "                       FROM FileErrors " & _
                    "                       WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '5'), " & _
                    "       OccupanyStandard   = (SELECT COUNT(fk_FileID)  " & _
                    "                            FROM FileErrors " & _
                    "	                         WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '6'),	" & _
                    "       AnnualReexamination   = (SELECT COUNT(fk_FileID) " & _
                    "                               FROM FileErrors " & _
                    "	                            WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '7'), " & _
                    "       InterimReexamination   = (SELECT COUNT(fk_FileID) " & _
                    "                                 FROM FileErrors " & _
                    "                                  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '8'),	" & _
                    "        Moves		     = (SELECT COUNT(fk_FileID) " & _
                    "                           FROM FileErrors " & _
                    "                           WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '9'), " & _
                    "       ChangeInFamilyComposition  = (SELECT COUNT(fk_FileID) " & _
                    "                                     FROM FileErrors " & _
                    "                                  	  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '10'), " & _
                    "       EligibilityAndScreening  = (SELECT COUNT(fk_FileID)  " & _
                    "                                   FROM FileErrors " & _
                    "	                                WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '11'), " & _
                    "       Leasing  = (SELECT COUNT(fk_FileID) " & _
                    "                  FROM FileErrors " & _
                    "                  WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '12'), " & _
                    "       DataEntry =  (SELECT COUNT(fk_FileID) " & _
                    "                     FROM FileErrors " & _
                    "                     WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '13'), " & _
                    "       LotteryNumber =   (SELECT COUNT(fk_FileID) " & _
                    "                          FROM LotteryNumberErrors " & _
                    "                          WHERE LotteryNumberErrors.fk_FileID =  Files.FileID), " & _
                    "       ReasonableRent = (SELECT COUNT(fk_FileID) " & _
                    "                         FROM FileErrors " & _
                    "	                      WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '15'), " & _
                    "       Portability =  (SELECT COUNT(fk_FileID) " & _
                    "                       FROM FileErrors  " & _
                    "	                    WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '16'), " & _
                    "       OwnerCertification = (SELECT COUNT(fk_FileID) " & _
                    "                               FROM FileErrors  " & _
                    "                               WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '17'), " & _
                    "       Document = (SELECT COUNT(fk_FileID) " & _
                    "                   FROM FileErrors " & _
                    "	                WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '18'), " & _
                    "       SpecialAdmission =  (SELECT COUNT(fk_FileID) " & _
                    "                            FROM SpecialCaseErrors " & _
                    "	                         WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '19'), " & _
                    "       PortIn = (SELECT COUNT(fk_FileID) " & _
                    "                 FROM SpecialCaseErrors " & _
                    "                 WHERE SpecialCaseErrors.fk_FileID =  Files.FileID AND fk_ErrorTypeID = '20'), " & _
                    "       Other =	(SELECT COUNT(fk_FileID) " & _
                    "               FROM FileErrors  " & _
                    "	            WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '21'), " & _
                    "       SelectionFromTheWaitlist = (SELECT COUNT(fk_FileID) " & _
                    "                                   FROM FileErrors " & _
                    "                                   WHERE FileErrors.fk_FileID = Files.FileID AND fk_ProcessTypeID = '22') " & _
                    "FROM Files " & _
                    "INNER JOIN Users As FileStaff ON Files.fk_CaseManagerID = FileStaff.UserID " & _
                    "INNER JOIN ReviewTypes ON Files.fk_ReviewTypeID = ReviewTypes.ReviewTypeID " & _
                    "INNER JOIN Users As Auditor ON Files.fk_AudtitorID = Auditor.UserID " & _
                    "INNER JOIN Groups ON FileStaff.fk_GroupID = Groups.GroupID " & _
                    "WHERE FileStaff.UserID = '" & userID & "'"

        SqlDataSource1.SelectCommand = sql
        SqlDataSource1.DataBind()
        GridView1.DataBind()
    End Sub

    Protected Sub ExportToExcel(ByVal sender As Object, ByVal e As EventArgs) Handles btnExportToExcel.Click
        Response.Clear()
        Response.Buffer = True
        Response.AddHeader("content-disposition", "attachment;filename=ReviewListExport.xls")
        Response.Charset = ""
        Response.ContentType = "application/vnd.ms-excel"
        Using writeContent As New StringWriter()
            Dim writeHtmlContent As New HtmlTextWriter(writeContent)
            Me.BindGridWithFilters()

            GridView1.RenderControl(writeHtmlContent)
            Response.Output.Write(writeContent.ToString())
            Response.Flush()
            Response.[End]()
        End Using
    End Sub

    Protected Sub FilterReport(ByVal sender As Object, ByVal e As EventArgs) Handles btnFilterReport.Click
        Me.BindGridWithFilters()
    End Sub

    Private Function GetAuditorIDForFile(ByVal fileID As Integer) As Integer
        conn.Open()
        Dim auditorID As Integer
        Dim query As New SqlCommand("SELECT fk_AudtitorID FROM Files WHERE FileID  = '" & fileID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()

        While reader.Read
            auditorID = CStr(reader("fk_AudtitorID"))
        End While
        conn.Close()

        Return auditorID
    End Function

    Private Function GetUserGroupID(ByVal userID As Integer) As Integer
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_GroupID FROM Users WHERE UserID  = '" & userID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        Dim groupID As Integer

        While reader.Read
            groupID = CStr(reader("fk_GroupID"))
        End While
        conn.Close()

        Return groupID
    End Function

    Public Function GetUserRoleID(ByVal sessionUserID As Integer) As Integer
        Dim roleID As Integer

        conn.Open()
        Dim query As New SqlCommand("SELECT fk_RoleID FROM Users WHERE UserID  = '" & sessionUserID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            roleID = CStr(reader("fk_RoleID"))
        End While
        conn.Close()

        Return roleID
    End Function

    Public Function GetSessionUserID() As Integer
        'Get user id from session to dictate which form will display
        Dim sessionUserID As String
        If Not Web.HttpContext.Current.Session("SessionUserID") Is Nothing Then
            sessionUserID = Web.HttpContext.Current.Session("SessionUserID").ToString()
        End If

        If sessionUserID = Nothing Then
            sessionUserID = Request.QueryString("SessionUserID")
            Web.HttpContext.Current.Session("SessionUserID") = sessionUserID
        End If

        Return Convert.ToInt32(sessionUserID)
    End Function

    Private Function IsFileDisabled(ByVal fileID As Integer) As Boolean
        Dim fileDisabled As Boolean

        conn.Open()
        Dim query As New SqlCommand("SELECT IsFileDisable FROM Files WHERE FileID  = '" & fileID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            fileDisabled = CStr(reader("IsFileDisable"))
        End While
        conn.Close()

        Return fileDisabled
    End Function

    Private Function ParseDate(ByVal dateToParse As String) As String()
        Dim dateSegments() As String = dateToParse.Split("/")
        Return dateSegments
    End Function

    Public Sub SetFiltersToAll()
        Group.AppendDataBoundItems = True
        Group.Items.Insert(0, New ListItem("ALL", 0))

        FileStaff.AppendDataBoundItems = True
        FileStaff.Items.Insert(0, New ListItem("ALL", 0))

        Auditor.AppendDataBoundItems = True
        Auditor.Items.Insert(0, New ListItem("ALL", 0))

        ReviewType.AppendDataBoundItems = True
        ReviewType.Items.Insert(0, New ListItem("ALL", 0))
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)
        ' Confirms that an HtmlForm control is rendered for the specified ASP.NET
        '     server control at run time. 
    End Sub
End Class