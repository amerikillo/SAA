<%-- 
    Document   : comparativoClave
    Created on : 8/04/2015, 04:04:27 PM
    Author     : Americo
--%>

<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="conn.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%
    ConectionDB con = new ConectionDB();
    //response.setContentType("application/vnd.ms-excel");
    //response.setHeader("Content-Disposition", "attachment;filename=\"Existencias_" + df2.format(new Date()) + "_.xls\"");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Estilos CSS -->
        <link href="../css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="../css/navbar-fixed-top.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="../css/dataTables.bootstrap.css">

        <!--<link href="//cdn.datatables.net/plug-ins/3cfcc339e89/integration/bootstrap/3/dataTables.bootstrap.css" rel="stylesheet" type="text/css"/>-->
        <title>SIALSS</title>
    </head>
    <body class="container">
        <table class="table table-bordered table-condensed table-striped" id="diferencias">
            <thead>
                <tr>
                    <td>Clave</td>
                    <td>Entradas</td>
                    <td>Salidas</td>
                    <td>Total</td>
                    <td>Existencia</td>
                    <td>Dif</td>
                    <td>Devol</td>
                    <td>Dif 2</td>
                </tr>
            </thead>
            <tbody>
                <%
                    con.conectar();
                    ResultSet rset = con.consulta("select F_ClaPro, SUM(F_ExiLot) as F_ExiLot from tb_lote group by F_ClaPro");
                    while (rset.next()) {
                        int cantComprada = 0;
                        int cantSurtida = 0;
                        int cantDevuelta = 0;
                        int existencia = rset.getInt("F_ExiLot");
                        ResultSet rset2 = con.consulta("select SUM(F_CanCom) as F_CanCom from tb_compra where F_ClaPro = '" + rset.getString("F_ClaPro") + "' group by F_ClaPro");
                        while (rset2.next()) {
                            cantComprada = rset2.getInt("F_CanCom");
                        }

                        rset2 = con.consulta("select F_ClaPro,sum(F_CantSur) as F_CantSur from tb_factura where F_ClaPro = '" + rset.getString("F_ClaPro") + "' GROUP BY F_ClaPro;");
                        while (rset2.next()) {
                            cantSurtida = rset2.getInt("F_CantSur");
                        }

                        rset2 = con.consulta("select F_ClaPro,sum(F_CantSur) as F_CantSur from tb_factura where F_StsFact='C' and F_ClaPro = '" + rset.getString("F_ClaPro") + "' GROUP BY F_ClaPro;");
                        while (rset2.next()) {
                            cantDevuelta = rset2.getInt("F_CantSur");
                        }
                        int dif1 = ((existencia) - (cantComprada - cantSurtida));
                        int dif2 = dif1 - cantDevuelta;
                %>
                <tr>
                    <td><%=rset.getString("F_ClaPro")%></td>
                    <td class="text-right"><%=cantComprada%></td>
                    <td class="text-right"><%=cantSurtida%></td>
                    <td class="text-right"><%=cantComprada - cantSurtida%></td>
                    <td class="text-right"><%=existencia%></td>
                    <td class="text-right"><%=dif1%></td>
                    <td class="text-right"><%=cantDevuelta%></td>
                    <td class="text-right"><%=dif2%></td>
                </tr>
                <%
                    }
                    con.cierraConexion();

                %>
            </tbody>
        </table>
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
                $("#diferencias").dataTable();
            });
        </script>
    </body>
</html>
