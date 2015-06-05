<%-- 
    Document   : eliminaConGlob
    Created on : 12/05/2015, 09:51:52 AM
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
    ConectionDB_ReqDist conReq = new ConectionDB_ReqDist();
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
            <%@include file="../jspf/menuPrincipal.jspf"%>
            <h3>Eliminar Concentrados Pasados</h3>
            <div id="divTablaConcen">
                <table class="table table-condensed table-bordered table-striped" id="tbReqGlob">
                    <thead>
                        <tr>
                            <td>ID Concentrado</td>
                            <td>Cla Uni</td>
                            <td>Unidad</td>
                            <td>F_FecEnt</td>
                            <td></td>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                con.conectar();
                                ResultSet rset = con.consulta("select f.F_IdFact, f.F_ClaCli, u.F_NomCli, f.F_FecEnt from tb_facttemp f, tb_uniatn u where u.F_ClaCli = f.F_ClaCli and  f.F_StsFact<5 group by f.F_IdFact;");
                                while (rset.next()) {
                        %>
                        <tr>
                            <td><%=rset.getString("F_IdFact")%></td>
                            <td><%=rset.getString("F_ClaCli")%></td>
                            <td><%=rset.getString("F_NomCli")%></td>
                            <td><%=rset.getString("F_FecEnt")%></td>
                            <td>
                                <button class="btn btn-sm btn-danger" name="boton" onclick="eliminaConGlob(this);" value="<%=rset.getString("F_IdFact")%>"><span class="glyphicon glyphicon-remove"></span></button>
                            </td>
                        </tr>
                        <%
                                }
                                con.cierraConexion();
                            } catch (Exception e) {

                            }
                        %>
                    </tbody>
                </table>
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
                                        $("#tbReqGlob").dataTable();
                                    });

                                    function eliminaConGlob(e) {
                                        var seguro = confirm('Seguro de eliminar?');
                                        if (seguro) {
                                            var F_IdFact = e.value;
                                            var dir = '../FacturacionManual?accion=ElimConcGlobPend&F_IdFact=' + F_IdFact;
                                            $.ajax({
                                                url: dir,
                                                type: 'POST',
                                                success: function(data) {
                                                    recargaTabla(data);
                                                },
                                                error: function() {
                                                    alert("Ha ocurrido un error");
                                                }
                                            });
                                            function recargaTabla(data) {
                                                //$('#divTablaConcen').load("eliminaConGlob.jsp #divTablaConcen");
                                                //$("#tbReqGlob").dataTable();
                                                // $("#divTabla").load("compraAuto4.jsp #divTabla");
                                                location.reload();
                                            }
                                        }
                                    }
        </script>
    </body>
</html>
