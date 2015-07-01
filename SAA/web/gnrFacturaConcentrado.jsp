<%-- 
    Document   : index
    Created on : 17/02/2014, 03:34:46 PM
    Author     : Americo
--%>

<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="conn.*" %>
<!DOCTYPE html>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatterDecimal = new DecimalFormat("#,###,##0.00");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator('.');
    custom.setGroupingSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    formatterDecimal.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
    String usua = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
    } else {
        //response.sendRedirect("index.jsp");
    }
    ConectionDB con = new ConectionDB();

    String fol_gnkl = "", fol_remi = "", orden_compra = "", fecha = "";
    fecha = request.getParameter("fecha");
    try {
        if (request.getParameter("accion").equals("buscar")) {
            fol_gnkl = request.getParameter("fol_gnkl");
            fol_remi = request.getParameter("fol_remi");
            orden_compra = request.getParameter("orden_compra");
        }
    } catch (Exception e) {

    }
    if (fol_gnkl == null) {
        fol_gnkl = "";
        fol_remi = "";
        orden_compra = "";
        fecha = "";
    }

    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-type", "application/xls");
    response.setHeader("Content-Disposition", "attachment;filename=\"RemisionGlobal.xls\"");
%>
<html>
    <head>
        <style>
            .num {
                mso-number-format:General;
            }
            .text{
                mso-number-format:"\@";/*force text*/
            }
        </style>
    </head>
    <body>
        <div>
            <h4>Global de Remisiones</h4>

            <br />
            <div class="panel panel-primary">
                <div class="panel-body">
                    <table class="table table-bordered table-striped" id="datosCompras" border="1">
                        <thead>
                            <tr>
                                <td>Cliente</td>
                                <td>FechaEnt</td>
                                <td>Remision</td>
                                <td>Clave</td>
                                <td>Descripción</td>
                                <td>Lote</td>
                                <td>Caducidad</td>
                                <td>Marca</td>
                                <td>FecFab</td>
                                <td>Req.</td>
                                <td>Ubicación</td>
                                <td>Ent.</td>
                                <td>Costo U</td>
                                <td>Importe</td>
                                <td>Status</td>
                                <td>No Entrega</td>
                                <td>Tipo</td>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                String where = "";
                                /*try {
                                 if (session.getAttribute("whereRF") == null) {
                                 where = "WHERE facturas.F_ClaMar = m.F_ClaMar AND (facturas.F_FecEnt BETWEEN '01/01/01' AND '01/01/01')";
                                 } else {
                                 where = "WHERE facturas.F_ClaMar = m.F_ClaMar AND (facturas.F_FecEnt BETWEEN DATE_FORMAT('"+session.getAttribute("fIniRF")+"','%d/%m/%Y') AND DATE_FORMAT('"+session.getAttribute("fFinRF")+"','%d/%m/%Y'))";
                                 }
                                 } catch (Exception ex) {
                                 where = "WHERE facturas.F_ClaMar = m.F_ClaMar AND (facturas.F_FecEnt BETWEEN '01/01/01' AND '01/01/01')";
                                 }*/
                                try {
                                    con.conectar();
                                    try {
                                        ResultSet rset = con.consulta("SELECT F_NomCli,F_FecEnt,F_ClaDoc,F_ClaPro,F_DesPro,F_ClaLot,F_FecCad,F_CantReq,F_CantSur,F_Costo,F_Monto, F_Ubicacion, F_StsFact, F_DesMar, DATE_FORMAT(F_FecFab,'%d/%m/%Y') AS F_FecFab, F_Req, F_Tipo FROM facturas, tb_marca m WHERE facturas.F_ClaMar = m.F_ClaMar and  F_Fecha between '2014-01-01' and '2014-12-31'");

                                        if (fecha.equals("2015")) {
                                            rset = con.consulta("SELECT F_NomCli,F_FecEnt,F_ClaDoc,F_ClaPro,F_DesPro,F_ClaLot,F_FecCad,F_CantReq,F_CantSur,F_Costo,F_Monto, F_Ubicacion, F_StsFact, F_DesMar, DATE_FORMAT(F_FecFab,'%d/%m/%Y') AS F_FecFab, F_Req, F_Tipo FROM facturas, tb_marca m WHERE facturas.F_ClaMar = m.F_ClaMar and F_Fecha between '2015-01-01' and '2015-12-31'");
                                        }
                                        while (rset.next()) {
                            %>
                            <tr>
                                <td><%=rset.getString(1)%></td>
                                <td><%=rset.getString(2)%></td>
                                <td><%=rset.getString(3)%></td>
                                <td><%=rset.getString(4)%></td>
                                <td><%=rset.getString(5)%></td>
                                <td class="text"><%=rset.getString(6)%></td>
                                <td><%=rset.getString(7)%></td>

                                <td><%=rset.getString("F_DesMar")%></td>
                                <td><%=rset.getString("F_FecFab")%></td>

                                <td><%=rset.getString(8)%></td>
                                <td><%=rset.getString(12)%></td>
                                <td><%=rset.getString(9)%></td>
                                <td><%=rset.getString(10)%></td>
                                <td><%=rset.getString(11)%></td>
                                <td><%=rset.getString("F_StsFact")%></td>
                                <td><%=rset.getString("F_Req")%></td>
                                <td><%=rset.getString("F_Tipo")%></td>
                            </tr>
                            <%
                                        }
                                    } catch (Exception e) {

                                    }
                                    con.cierraConexion();
                                } catch (Exception e) {

                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </body>
</html>
