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
/**
 * Para exportar el requerimiento
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
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment;filename=\"Requerimiento_" + request.getParameter("F_Id") + ".xls\"");
%>
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
