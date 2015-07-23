<%-- 
    Document   : descargarReq
    Created on : 4/03/2015, 04:26:43 PM
    Author     : Americo
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="conn.ConectionDB_ReqDist"%>
<%
    /**
     * Para exportar los requerimientos de los distribuidores desde la base de
     * datos gnkl_reqisemcc.
     */
    HttpSession sesion = request.getSession();
    String usua = "", tipo = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
        tipo = (String) sesion.getAttribute("Tipo");
    } else {
        response.sendRedirect("index.jsp");
    }
    ConectionDB_ReqDist conReq = new ConectionDB_ReqDist();
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment;filename=\"Requerimiento" + request.getParameter("F_ClaCli") + "_" + request.getParameter("F_IdPed") + ".xls\"");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
*
<table border="1">
    <tr>
        <td>Cla Cli</td>
        <td>Cliente</td>
        <td>IdPed</td>
        <td>Fecha</td>
        <td>Cla Pro</td>
        <td>Descripcion</td>
        <td>Cantidad</td>
        <td>Tipo</td>
    </tr>
    <%
        try {
            conReq.conectar();
            ResultSet rset = conReq.consulta("select * from v_requerimientos where F_ClaCli = '" + request.getParameter("F_ClaCli") + "' and F_IdPed = '" + request.getParameter("F_IdPed") + "' ");
            while (rset.next()) {
    %>
    <tr>
        <td><%=rset.getString(1)%></td>
        <td><%=rset.getString(2)%></td>
        <td><%=rset.getString(3)%></td>
        <td><%=rset.getString(5)%></td>
        <td><%=rset.getString(6)%></td>
        <td><%=rset.getString(7)%></td>
        <td><%=rset.getString(8)%></td>
        <td><%=rset.getString(9)%></td>
    </tr>
    <%
            }
            conReq.cierraConexion();
        } catch (Exception e) {
            out.println(e);
        }
    %>
</table>