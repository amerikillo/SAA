<%-- 
    Document   : conexionModula
    Created on : 13/10/2014, 03:21:27 PM
    Author     : Americo
--%>

<%@page import="conn.ConectionDB_SQLServer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    ConectionDB_SQLServer con = new ConectionDB_SQLServer();

    if (con.conectar()) {
        out.println("Conexión Exitosa");
    } else {
        out.println("Conexión Fallida");
    }

%>
