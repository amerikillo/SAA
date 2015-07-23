<%-- 
    Document   : exist
    Created on : 02-jul-2014, 23:24:11
    Author     : wence
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
    DecimalFormat formatter2 = new DecimalFormat("#,###,###.##");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
    String usua = "ISEM", Clave = "1", Claves = "", Kardex = "";
    ResultSet rset;
    ResultSet rset2;

    /*if (sesion.getAttribute("nombre") != null) {
     usua = (String) sesion.getAttribute("nombre");
     Clave = (String) session.getAttribute("clave");
     } else {
     response.sendRedirect("index.jsp");
     }
     if (Clave== null){
     Clave="";
     }*/
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; filename=Reporte Semaforizacion.xls");

    ConectionDB con = new ConectionDB();
%>

<table cellpadding="0" cellspacing="0" border="1" class="table table-striped table-bordered" id="datosProv">
    <thead>
        <tr>
            <td>Clave</td>
            <td>Descripción</td>
            <td>Lote</td>
            <td>Caducidad</td>                                
            <td>Cantidad</td>
            <td>Costo U.</td>
            <td>Monto</td>
            <td>Semaforización</td>
        </tr>
    </thead>
    <tbody>
        <%
            int Cantidad = 0;
            double monto = 0, montof = 0;
            try {

                con.conectar();
                rset = con.consulta("SELECT l.F_ClaPro, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') AS F_FecCad, SUM(F_ExiLot), (m.F_Costo*SUM(l.F_ExiLot)) as monto,m.F_Costo FROM tb_lote l, tb_medica m, tb_ubica u WHERE m.F_ClaPro = l.F_ClaPro AND l.F_Ubica = u.F_ClaUbi AND F_ExiLot != 0 AND F_FecCad < DATE_ADD(CURDATE(), INTERVAL 9 MONTH) GROUP BY l.F_ClaPro,l.F_ClaLot,l.F_FecCad");
                while (rset.next()) {
        %>
        <tr>
            <td><%=rset.getString(1)%></td>
            <td><%=rset.getString(2)%></td>
            <td><%=rset.getString(3)%></td>
            <td><%=rset.getString(4)%></td>
            <td><%=formatter.format(rset.getInt(5))%></td>
            <td><%=formatter2.format(rset.getDouble(7))%></td>
            <td><%=formatter2.format(rset.getDouble(6))%></td>
            <td><span class="label label-danger">Menor 9 Meses</span></td>
        </tr>
        <%
                }
                rset2 = con.consulta("SELECT SUM(F_ExiLot) as suma,sum((m.F_Costo*l.F_ExiLot)) as monto, l.F_ClaPro FROM tb_lote l INNER JOIN tb_medica m on l.F_ClaPro=m.F_ClaPro where F_FecCad < DATE_ADD(CURDATE(), INTERVAL 9 MONTH) group by l.F_ClaPro");
                while (rset2.next()) {
                    double monto1 = 0;
                    if (rset2.getFloat("F_ClaPro") < 9999.0) {
                        monto1 = Double.parseDouble(rset2.getString("monto"));
                    } else {
                        monto1 = (Double.parseDouble(rset2.getString("monto")) * 1.16);
                    }
                    Cantidad = Cantidad + Integer.parseInt(rset2.getString("suma"));
                    monto = monto + monto1;
                }
                con.cierraConexion();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        %>
    </tbody>

</table>
<h3>Total Piezas = <%=formatter.format(Cantidad)%>&nbsp;&nbsp;&nbsp;Monto Total = $<%=formatter2.format(monto)%></h3>


<table cellpadding="0" cellspacing="0" border="1" class="table table-striped table-bordered" id="datosProv">
    <thead>
        <tr>
            <td>Clave</td>
            <td>Descripción</td>
            <td>Lote</td>
            <td>Caducidad</td>                                
            <td>Cantidad</td>
            <td>Costo U.</td>
            <td>Monto</td>
            <td>Semaforización</td>
        </tr>
    </thead>
    <tbody>
        <%

            Cantidad = 0;
            monto = 0;
            montof = 0;
            try {
                con.conectar();
                rset = con.consulta("SELECT l.F_ClaPro, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') AS F_FecCad, SUM(F_ExiLot), (m.F_Costo*SUM(l.F_ExiLot)) as monto,m.F_Costo FROM tb_lote l, tb_medica m, tb_ubica u WHERE m.F_ClaPro = l.F_ClaPro AND l.F_Ubica = u.F_ClaUbi AND F_ExiLot != 0 AND F_FecCad BETWEEN DATE_ADD(CURDATE(), INTERVAL 9 MONTH) AND DATE_ADD(CURDATE(), INTERVAL 12 MONTH) GROUP BY l.F_ClaPro,l.F_ClaLot,l.F_FecCad");
                while (rset.next()) {
        %>
        <tr>
            <td><%=rset.getString(1)%></td>
            <td><%=rset.getString(2)%></td>
            <td><%=rset.getString(3)%></td>
            <td><%=rset.getString(4)%></td>
            <td><%=formatter.format(rset.getInt(5))%></td>
            <td><%=formatter2.format(rset.getDouble(7))%></td>
            <td><%=formatter2.format(rset.getDouble(6))%></td>
            <td><span class="label label-warning">Entre 9 y 12 Meses</span></td>
        </tr>
        <%
                }
                rset2 = con.consulta("SELECT SUM(F_ExiLot) as suma,sum((m.F_Costo*l.F_ExiLot)) as monto, l.F_ClaPro FROM tb_lote l INNER JOIN tb_medica m on l.F_ClaPro=m.F_ClaPro where F_FecCad BETWEEN DATE_ADD(CURDATE(), INTERVAL 9 MONTH) AND DATE_ADD(CURDATE(), INTERVAL 12 MONTH) group by l.F_ClaPro");
                while (rset2.next()) {
                    double monto1 = 0;
                    if (rset2.getFloat("F_ClaPro") < 9999.0) {
                        monto1 = Double.parseDouble(rset2.getString("monto"));
                    } else {
                        monto1 = (Double.parseDouble(rset2.getString("monto")) * 1.16);
                    }
                    Cantidad = Cantidad + Integer.parseInt(rset2.getString("suma"));
                    monto = monto + monto1;
                }
                con.cierraConexion();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        %>
    </tbody>

</table>
<h3>Total Piezas = <%=formatter.format(Cantidad)%>&nbsp;&nbsp;&nbsp;Monto Total = $<%=formatter2.format(monto)%></h3>



<table cellpadding="0" cellspacing="0" border="1" class="table table-striped table-bordered" id="datosProv">
    <thead>
        <tr>
            <td>Clave</td>
            <td>Descripción</td>
            <td>Lote</td>
            <td>Caducidad</td>                                
            <td>Cantidad</td>
            <td>Costo U.</td>
            <td>Monto</td>
            <td>Semaforización</td>
        </tr>
    </thead>
    <tbody>
        <%
            Cantidad = 0;
            monto = 0;
            montof = 0;
            try {
                con.conectar();

                rset = con.consulta("SELECT l.F_ClaPro, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') AS F_FecCad, SUM(F_ExiLot), (m.F_Costo*SUM(l.F_ExiLot)) as monto,m.F_Costo FROM tb_lote l, tb_medica m, tb_ubica u WHERE m.F_ClaPro = l.F_ClaPro AND l.F_Ubica = u.F_ClaUbi AND F_ExiLot != 0 AND F_FecCad > DATE_ADD(CURDATE(), INTERVAL 12 MONTH) GROUP BY l.F_ClaPro,l.F_ClaLot,l.F_FecCad");
                while (rset.next()) {
        %>
        <tr>
            <td><%=rset.getString(1)%></td>
            <td><%=rset.getString(2)%></td>
            <td><%=rset.getString(3)%></td>
            <td><%=rset.getString(4)%></td>
            <td><%=formatter.format(rset.getInt(5))%></td>
            <td><%=formatter2.format(rset.getDouble(7))%></td>
            <td><%=formatter2.format(rset.getDouble(6))%></td>
            <td><span class="label label-success"> Mayor a 12 Meses</span></td>

        </tr>
        <%
                }
                rset2 = con.consulta("SELECT SUM(F_ExiLot) as suma,sum((m.F_Costo*l.F_ExiLot)) as monto, l.F_ClaPro FROM tb_lote l INNER JOIN tb_medica m on l.F_ClaPro=m.F_ClaPro where F_FecCad > DATE_ADD(CURDATE(), INTERVAL 12 MONTH) group by l.F_ClaPro");
                while (rset2.next()) {
                    double monto1 = 0;
                    if (rset2.getFloat("F_ClaPro") < 9999.0) {
                        monto1 = Double.parseDouble(rset2.getString("monto"));
                    } else {
                        monto1 = (Double.parseDouble(rset2.getString("monto")) * 1.16);
                    }
                    Cantidad = Cantidad + Integer.parseInt(rset2.getString("suma"));
                    monto = monto + monto1;
                }
                con.cierraConexion();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        %>
    </tbody>

</table>
<h3>Total Piezas = <%=formatter.format(Cantidad)%>&nbsp;&nbsp;&nbsp;Monto Total = $<%=formatter2.format(monto)%></h3>