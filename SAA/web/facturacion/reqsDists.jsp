<%-- 
    Document   : reqsDists
    Created on : 4/03/2015, 04:16:48 PM
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
    /**
     * Listado de los requerimientos que se liberan por ISEM para posterior a
     * eso remisionarse
     */
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

            <div>
                <h3>Distribuidores</h3>
            </div>
            <h3>Requerimientos Revisados</h3>

            <table id="tblReq2" class="table table-condensed table-bordered table-striped">
                <thead> <tr>
                        <td>Distribuidor</td>
                        <td>ID Pedido</td>
                        <td>Status</td>
                        <td>Fecha de Captura</td>
                        <td>Tipo</td>
                        <td width="100px"></td>
                    </tr></thead>
                    <%
                        try {
                            conReq.conectar();
                            ResultSet rset = conReq.consulta("select u.F_NomCli, p.F_IdPed, p.F_StsPed, DATE_FORMAT(p.F_FecCap,'%d/%m/%Y %H:%i:%s')as F_FecCap, p.F_ClaCli, p.F_TipoPed from tb_pedidos p, tb_uniatn u where p.F_ClaCli = u.F_ClaCli and F_StsPed=4");
                            while (rset.next()) {
                                String color = "warning";
                                String status = "Confirmado";
                                if (rset.getString("F_StsPed").equals("1")) {
                                    status = "Eliminado";
                                    color = "danger";
                                }
                                if (rset.getString("F_StsPed").equals("2")) {
                                    status = "Capturado";
                                    color = "success";
                                }
                    %>
                <tr class="<%//=color%>">
                    <td><%=rset.getString("F_NomCli")%></td>
                    <td><%=rset.getString("F_IdPed")%></td>
                    <td><%=status%></td>
                    <td><%=rset.getString("F_FecCap")%></td>
                    <td><%=rset.getString("F_TipoPed")%></td>
                    <td>
                        <div class="row">
                            <form action="descargarReq.jsp" method="post" class="col-sm-6">
                                <input value="<%=rset.getString("F_IdPed")%>" name="F_IdPed"  class="hidden" />
                                <input value="Si" name="Validado"  class="hidden" />
                                <input value="<%=rset.getString("p.F_ClaCli")%>" name="F_ClaCli"  class="hidden" />
                                <button class="btn btn-primary btn-sm" name="accion" value="EliminarInsumo"><span class="glyphicon glyphicon-download"></span></button>
                            </form>
                            <a class="btn btn-success btn-sm"  href="../requerimientoPDF.jsp?F_IdPed=<%=rset.getString("F_IdPed")%>&F_ClaCli=<%=rset.getString("p.F_ClaCli")%>"><span class="glyphicon glyphicon-print"></span></a>

                            <!--form action="Capturar?F_IdPed=<%=rset.getString("F_IdPed")%>" method="post" class="col-sm-6">
                                <button class="btn btn-danger btn-sm" name="accion" onclick="return confirm('Seguro que desea eliminar el pedido?')" value="EliminarPedido">X</button>
                            </form-->
                        </div>
                    </td>
                </tr>
                <%
                        }
                        conReq.cierraConexion();
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

