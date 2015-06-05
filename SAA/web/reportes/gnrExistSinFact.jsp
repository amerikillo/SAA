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
    String usua = "ISEM", Clave = "1", Claves = "";
    ResultSet rset;
    ResultSet rset2;
    int Cantidad = 0;
    double monto = 0, montof = 0;

    /*if (sesion.getAttribute("nombre") != null) {
     usua = (String) sesion.getAttribute("nombre");
     Clave = (String) session.getAttribute("clave");
     } else {
     response.sendRedirect("index.jsp");
     }
     if (Clave== null){
     Clave="";
     }*/
    ConectionDB con = new ConectionDB();

    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; filename=Existencias en CEDIS sin Facts.xls");
%>
<table cellpadding="0" cellspacing="0" border="1" class="table table-striped table-bordered" id="datosProv">
    <thead>
        <tr>
            <td>Clave</td>
            <td>Descripción</td>
            <td>Marca</td>
            <td>Cantidad</td>
            <td>Costo U.</td>
            <td>Monto</td>
        </tr>
    </thead>
    <tbody>
        <%
            try {
                con.conectar();

                Claves = request.getParameter("clave");
                if (Claves == null) {
                    Claves = "";
                }

                if (Claves.equals("")) {
                    rset = con.consulta("SELECT l.F_ClaPro, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') AS F_FecCad, l.F_Ubica, l.F_Cb, SUM(F_ExiLot), u.F_DesUbi,(m.F_Costo*SUM(l.F_ExiLot)) as monto,m.F_Costo, F_DesMar, l.F_FecCad as F_FechaCad FROM tb_marca mar, tb_lote l, tb_medica m, tb_ubica u WHERE mar.F_ClaMar = l.F_ClaMar and m.F_ClaPro = l.F_ClaPro AND l.F_Ubica = u.F_ClaUbi AND F_ExiLot != 0 GROUP BY l.F_ClaPro");
                } else {
                    rset = con.consulta("SELECT l.F_ClaPro, m.F_DesPro, l.F_ClaLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') AS F_FecCad, l.F_Ubica, l.F_Cb, SUM(F_ExiLot), u.F_DesUbi,(m.F_Costo*SUM(l.F_ExiLot)) as monto,m.F_Costo, F_DesMar, l.F_FecCad as F_FechaCad FROM tb_marca mar, tb_lote l, tb_medica m, tb_ubica u WHERE mar.F_ClaMar = l.F_ClaMar and m.F_ClaPro = l.F_ClaPro AND l.F_Ubica = u.F_ClaUbi AND F_ExiLot != 0 and l.F_ClaPro='" + Claves + "' GROUP BY l.F_ClaPro");
                }
                while (rset.next()) {
                    double monto1 = 0, montoApar=0;
                    int cantExi = rset.getInt(7);
                    int cantTotal = 0, cantApar = 0;
                    System.out.println(rset.getString(1));
                    if (rset.getInt("F_ClaPro") < 9999) {
                        monto1 = Double.parseDouble(rset.getString("monto"));
                    } else {
                        monto1 = (Double.parseDouble(rset.getString("monto")) * 1.16);
                    }

                    ResultSet rset3 = con.consulta("select SUM(F_Cant) as F_Cant, SUM(c.F_Cant * m.F_Costo) as Importe from clavefact c, tb_medica m where m.F_ClaPro = c.F_ClaPro and c.F_ClaPro = '" + rset.getString("F_ClaPro") + "' and F_StsFact<5 ");
                    while (rset3.next()) {
                        cantApar = rset3.getInt("F_Cant");
                        montoApar = rset3.getDouble("Importe");
                    }
                    cantTotal = cantExi - cantApar;
                    Cantidad = Cantidad + cantTotal;
                    monto = monto + monto1;
                    monto = monto - montoApar;
        %>
        <tr>
            <td><%=rset.getString(1)%></td>
            <td><%=rset.getString(2)%></td>
            <td><%=rset.getString("F_DesMar")%></td>
            <td><%=formatter.format(cantTotal)%></td>
            <td><%=formatter2.format(rset.getDouble(10))%></td>
            <td><%=formatter2.format(monto1)%></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println(e);
            }
        %>
    </tbody>

</table>
<h3>Total Piezas = <%=formatter.format(Cantidad)%>&nbsp;&nbsp;&nbsp;Monto Total = $<%=formatter2.format(monto)%></h3>
