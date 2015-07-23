/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Facturacion;

import conn.ConectionDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONObject;

/**
 *
 * @author ALEJO COLOMBIA
 */
public class Concentrados extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * 
     * 
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession sesion = request.getSession();
        ConectionDB con = new ConectionDB();
        JSONObject json = new JSONObject();
        try {
            /**
             * Para buscar el id de un concentrado para editarlo.
             * imprime el json que se leerá en el archivo SAA/reimpConcentrado.jsp
             */
            if (request.getParameter("que").equals("b")) {
                try {
                    con.conectar();
                    ResultSet rs = con.consulta("SELECT l.F_ClaPro, l.F_ClaLot, l.F_FecCad, ft.F_Cant, l.F_ExiLot,F_Id FROM tb_facttemp AS ft INNER JOIN tb_lote AS l ON l.F_IdLote = ft.F_IdLot"
                            + " WHERE ft.F_Id = '" + request.getParameter("id") + "'");
                    if (rs.next()) {
                        json.put("id", rs.getString(6));
                        json.put("clave", rs.getString(1));
                        json.put("lote", rs.getString(2));
                        json.put("caduc", rs.getString(3));
                        json.put("cant", rs.getString(4));
                        json.put("exis", rs.getString(5));
                        json.put("msg", 1);
                    } else {
                        json.put("msg", 0);
                    }
                    con.cierraConexion();
                    out.println(json);
                   
                } catch (Exception ex) {
                    System.out.println("ErroB->" + ex);
                }
            }
            /**
             * Para editar la cantidad del id en la tabla tb_facttemp
             * imprime bandera 'msg' 1 si success 0 si error
             */
            else if (request.getParameter("que").equals("mod")) {
                try {
                    con.conectar();
                    con.actualizar("update tb_facttemp set F_Cant='"+request.getParameter("cant")+"' where F_Id='"+request.getParameter("id")+"'");
                    json.put("msg","1");
                    con.cierraConexion();
                } catch (Exception ex) {
                    System.out.println("ErroMod->" + ex);
                    json.put("msg","0");              
                }
                out.print(json);
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
