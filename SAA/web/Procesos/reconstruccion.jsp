<%-- 
    Document   : reconstruccion
    Created on : 26/05/2015, 11:05:34 AM
    Author     : Americo
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="conn.ConectionDB"%>
<table border="1">

    <%
        /**
         * No SE USA
         */

        ConectionDB con = new ConectionDB();
        con.conectar();
        ResultSet rset = con.consulta("select F_ClaPro, F_ExiLot, F_Ubica from tb_lote where F_FolLot='2174' ");
        while (rset.next()) {
            int cant = 0;
            ResultSet rset2 = con.consulta("select F_CantMov*F_SigMov as total from tb_movinv where F_LotMov='2174' and F_UbiMov='" + rset.getString("F_Ubica") + "'");
            while (rset2.next()) {
                cant = cant + rset2.getInt("total");
            }
    %>
    <tr>
        <td><%=rset.getString("F_ClaPro")%></td>
        <td><%=rset.getString("F_Ubica")%></td>
        <td><%=rset.getString("F_ExiLot")%></td>
        <td><%=cant%></td>
    </tr>
    <%
        }
        con.cierraConexion();
    %></table>