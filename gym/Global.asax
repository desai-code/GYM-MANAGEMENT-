<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
    }

    void Application_Error(object sender, EventArgs e)
    {
        // Real errors go to App_Data\error.log, visitors only see the friendly Error.html page.
        Exception ex = Server.GetLastError();
        if (ex != null) DbHelper.Log(ex);
    }

</script>
