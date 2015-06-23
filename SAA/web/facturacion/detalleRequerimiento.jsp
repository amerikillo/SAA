<%-- 
    Document   : detalleRequerimiento
    Created on : 5/06/2015, 03:56:55 PM
    Author     : Americo
--%>


<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="conn.*" %>
<!DOCTYPE html>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%
    
    HttpSession sesion = request.getSession();
    String usua = "", tipo = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
        tipo = (String) sesion.getAttribute("Tipo");
    } else {
        response.sendRedirect("index.jsp");
    }
    ConectionDB con = new ConectionDB();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Estilos CSS -->
        <link href="../css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/cupertino/jquery-ui-1.10.3.custom.css" />

        <link rel="stylesheet" type="text/css" href="../css/dataTables.bootstrap.css">

        <!--<link href="//cdn.datatables.net/plug-ins/3cfcc339e89/integration/bootstrap/3/dataTables.bootstrap.css" rel="stylesheet" type="text/css"/>-->
        <title>SIALSS</title>
    </head>
    <body>
        <div class="container">
            <h1>SIALSS</h1>
            <h4>Módulo - Sistema de Administración de Almacenes (SAA)</h4>
            <hr/>
            <div>
                <h3>Detalle Requerimiento</h3>
            </div>

            <table id="tblReq2" class="table table-condensed table-bordered table-striped">
                <thead> 
                    <tr>
                        <td>ID Requerimiento</td>
                        <td>Distribuidor</td>
                        <td>Fecha de Subida</td>
                        <td>Clave</td>
                        <td>Total piezas</td>
                    </tr></thead>
                    <%                        
                        try {
                            con.conectar();
                            ResultSet rset = con.consulta("select u.F_ClaCli, u.F_NomCli, r.F_Id, DATE_FORMAT(r.F_FecCarg, '%d/%m/%Y') as F_FecCarga, (F_PiezasReq) as F_PiezasReq, F_ClaPro from tb_unireq r, tb_uniatn u where u.F_ClaCli=r.F_ClaUni and r.F_Id!='' and F_Status!='1' and F_Id='" + request.getParameter("F_Id") + "' ");
                            while (rset.next()) {
                    %>
                <tr>
                    <td><%=rset.getString("F_Id")%></td>
                    <td><%=rset.getString("F_NomCli")%></td>
                    <td><%=rset.getString("F_FecCarga")%></td>
                    <td><%=rset.getString("F_ClaPro")%></td>
                    <td class="text-right"><%=rset.getString("F_PiezasReq")%></td>
                </tr>
                <%
                        }
                        con.cierraConexion();
                    } catch (Exception e) {
                        out.println(e);
                    }                    
                %>
            </table>
        </div>
        <br><br><br>
        <div class="navbar navbar-fixed-bottom navbar-inverse">
            <div class="text-center text-muted">
                GNK Logística || Desarrollo de Aplicaciones 2009 - 2015 <span class="glyphicon glyphicon-registration-mark"></span><br />
                Todos los Derechos Reservados
            </div>
        </div>
        <!-- 
            ================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui-1.10.3.custom.js"></script>
        <script src="../js/jquery.dataTables.js"></script>
        <script src="../js/dataTables.bootstrap.js"></script>
        <script type="text/javascript">
                        $(document).ready(function() {
                            $("#tblReq2").dataTable();
                        });
        </script>

    </body>
</html>

