Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.Services
Public Class ContactList
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Me.BindDummyRow()
        End If
    End Sub
    Private Sub BindDummyRow()
        Dim dummy As New DataTable()
        dummy.Columns.Add("Id")
        dummy.Columns.Add("Name")
        dummy.Columns.Add("Address")
        dummy.Columns.Add("Phone")
        dummy.Rows.Add()
        gvContacts.DataSource = dummy
        gvContacts.DataBind()
    End Sub

    Public Shared Function GetContacts() As String
        Dim query As String = "SELECT Id, username, address,phone FROM Contacts"
        Dim cmd As New SqlCommand(query)
        Dim constr As String = ConfigurationManager.ConnectionStrings("PharmacyDB").ConnectionString
        Using con As New SqlConnection(constr)
            Using sda As New SqlDataAdapter()
                cmd.Connection = con
                sda.SelectCommand = cmd
                Using ds As New DataSet()
                    sda.Fill(ds)
                    Return ds.GetXml()
                End Using
            End Using
        End Using
    End Function
    Public Shared Function InsertContact(name As String, address As String, phone As String) As Integer
        Dim constr As String = ConfigurationManager.ConnectionStrings("PharmacyDB").ConnectionString
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand("INSERT INTO Contacts VALUES(@Name, @Address, @Phone) SELECT SCOPE_IDENTITY()")
                cmd.Parameters.AddWithValue("@Name", name)
                cmd.Parameters.AddWithValue("@Address", address)
                cmd.Parameters.AddWithValue("@Phone", phone)
                cmd.Connection = con
                con.Open()
                Dim Id As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                con.Close()
                Return ID
            End Using
        End Using
    End Function

    <WebMethod()>
    Public Shared Sub UpdateContact(Id As Integer, name As String, address As String, phone As String)
        Dim constr As String = ConfigurationManager.ConnectionStrings("PharmacyDB").ConnectionString
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand("UPDATE Contacts SET Name = @Name, Country = @Country WHERE CustomerId = @CustomerId")
                cmd.Parameters.AddWithValue("@CustomerId", Id)
                cmd.Parameters.AddWithValue("@Address", address)
                cmd.Parameters.AddWithValue("@Phone", phone)
                cmd.Connection = con
                con.Open()
                cmd.ExecuteNonQuery()
                con.Close()
            End Using
        End Using
    End Sub

    <WebMethod()>
    Public Shared Sub DeleteContact(Id As Integer)
        Dim constr As String = ConfigurationManager.ConnectionStrings("PharmacyDB").ConnectionString
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand("DELETE FROM Contacts WHERE Id = @Id")
                cmd.Parameters.AddWithValue("@Id", Id)
                cmd.Connection = con
                con.Open()
                cmd.ExecuteNonQuery()
                con.Close()
            End Using
        End Using
    End Sub
End Class