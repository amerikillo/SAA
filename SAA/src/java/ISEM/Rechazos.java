/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ISEM;

import Correo.CorreoRechaza;
import conn.ConectionDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Americo
 */
public class Rechazos extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        ConectionDB con = new ConectionDB();
        DateFormat df2 = new SimpleDateFormat("dd/MM/yyyy");
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        PrintWriter out = response.getWriter();
        CorreoRechaza correo = new CorreoRechaza();
        try {
            try {

                if (request.getParameter("accion").equals("Rechazar")) {
                    try {
                        con.conectar();
                        String fechaA = "", horaA = "";
                        ResultSet rset = con.consulta("select F_FecSur, F_HorSur from tb_pedidoisem where F_NoCompra = '" + request.getParameter("NoCompraRechazo") + "'");
                        while (rset.next()) {
                            fechaA = rset.getString(1);
                            horaA = rset.getString(2);
                        }
                        byte[] a = request.getParameter("rechazoObser").getBytes("ISO-8859-1");
                        String Observaciones = (new String(a, "UTF-8"));

                        con.insertar("insert into tb_rechazos values (0,'" + request.getParameter("NoCompraRechazo") + "','" + Observaciones + "', NOW())");
                        con.insertar("update tb_pedidoisem set F_FecSur = '" + request.getParameter("FechaOrden") + "' , F_HorSur = '" + request.getParameter("HoraOrden") + "' where F_NoCompra = '" + request.getParameter("NoCompraRechazo") + "' ");
                        //con.insertar("update tb_pedidoisem set F_Recibido = '2' where F_NoCompra = '" + request.getParameter("NoCompraRechazo") + "' ");
                        correo.enviaCorreo(request.getParameter("NoCompraRechazo"), horaA, fechaA, request.getParameter("correoProvee"));
                        con.cierraConexion();
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                    response.sendRedirect("compraAuto2.jsp");
                }
            } catch (Exception e) {
            }
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
