/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Distribuidor;

import conn.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Americo
 */
public class AbastecerDistribuidor extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     *
     * Se utiliza el método para enviár lo que se remisiona a los
     * distribuidores, en este caso SAVI - GNKL
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        ConectionDB con = new ConectionDB();
        ConectionDB_Medalfa conMedalfa = new ConectionDB_Medalfa();//Conexion a BDD medalfa
        ConectionDB_CedisSendero conSendero = new ConectionDB_CedisSendero();//Conexion a BDD Cedis Sendero
        HttpSession sesion = request.getSession(true);
        try {
            try {
                //accion enviar Medalfa
                if (request.getParameter("accion").equals("enviarMedalfa")) {
                    try {
                        con.conectar();
                        conMedalfa.conectar();
                        //Se leé lo generado en la remisión
                        ResultSet rset = con.consulta("SELECT U.F_NomCli,DATE_FORMAT(F.F_FecEnt,'%d/%m/%Y') AS F_FecEnt,F.F_ClaDoc,F.F_ClaPro,M.F_DesPro,L.F_ClaLot,L.F_FecCad,(F.F_CantSur) as surtido,(F.F_CantReq) as requerido,F.F_Costo,(F.F_Monto) as importe, F.F_Ubicacion, L.F_ClaOrg, L.F_Cb, L.F_ClaMar, L.F_FecFab FROM tb_factura F INNER JOIN tb_medica M ON F.F_ClaPro=M.F_ClaPro INNER JOIN tb_lote L ON F.F_Lote=L.F_FolLot INNER JOIN tb_uniatn U ON F.F_ClaCli=U.F_ClaCli WHERE F.F_ClaDoc='" + request.getParameter("F_ClaDoc") + "' GROUP BY F.F_IdFact");
                        while (rset.next()) {
                            double impuesto = 0.0;
                            impuesto = rset.getDouble("F_Costo") * rset.getDouble("surtido");
                            //Se arma query de inserción
                            String qry = "insert into tb_compratemp values ('0',CURDATE(),'" + rset.getString("F_ClaPro") + "','" + rset.getString("F_ClaLot") + "','" + rset.getString("F_FecCad") + "','" + rset.getString("F_FecFab") + "','" + rset.getString("F_ClaMar") + "','" + rset.getString("F_ClaOrg") + "','" + rset.getString("F_Cb") + "','1','1','" + rset.getString("surtido") + "','0','0','0','" + rset.getString("F_Costo") + "','" + impuesto + "','" + rset.getString("importe") + "','Se envía desde SAA CC','" + request.getParameter("F_ClaDoc") + "','" + request.getParameter("F_ClaDoc") + "','" + rset.getString("F_ClaOrg") + "','" + sesion.getAttribute("nombre") + "','2','1')";
                            System.out.println(qry);
                            try {
                                //Se inserta en la tabla de tb_compratemp los datos de la remisión
                                conMedalfa.insertar(qry);
                            } catch (Exception e) {
                                System.out.println(e.getMessage());
                            }
                        }
                        conMedalfa.cierraConexion();
                        con.cierraConexion();
                        response.sendRedirect("reimp_factura.jsp");
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                }

                //Accion de enviar a CEDIS Sendero (SAVI GNKL)
                if (request.getParameter("accion").equals("enviarCEDISSendero")) {
                    try {
                        con.conectar();
                        conSendero.conectar();
                        //Lectura de los datos de la remisión
                        ResultSet rset = con.consulta("SELECT U.F_NomCli,DATE_FORMAT(F.F_FecEnt,'%d/%m/%Y') AS F_FecEnt,F.F_ClaDoc,F.F_ClaPro,M.F_DesPro,L.F_ClaLot,L.F_FecCad,(F.F_CantSur) as surtido,(F.F_CantReq) as requerido,F.F_Costo,(F.F_Monto) as importe, F.F_Ubicacion, L.F_ClaOrg, L.F_Cb, L.F_ClaMar, L.F_FecFab FROM tb_factura F INNER JOIN tb_medica M ON F.F_ClaPro=M.F_ClaPro INNER JOIN tb_lote L ON F.F_Lote=L.F_FolLot INNER JOIN tb_uniatn U ON F.F_ClaCli=U.F_ClaCli WHERE F.F_ClaDoc='" + request.getParameter("F_ClaDoc") + "' and F_StsFact='A' GROUP BY F.F_IdFact");
                        while (rset.next()) {
                            double impuesto = 0.0;
                            impuesto = rset.getDouble("F_Costo") * rset.getDouble("surtido");
                            //Se arma query de inserción
                            String qry = "insert into tb_compratemp values ('0',CURDATE(),'" + rset.getString("F_ClaPro") + "','" + rset.getString("F_ClaLot") + "','" + rset.getString("F_FecCad") + "','" + rset.getString("F_FecFab") + "','" + rset.getString("F_ClaMar") + "','" + rset.getString("F_ClaOrg") + "','" + rset.getString("F_Cb") + "','1','1','" + rset.getString("surtido") + "','0','0','0','" + rset.getString("F_Costo") + "','" + impuesto + "','" + rset.getString("importe") + "','Se envía desde SAA CC','" + request.getParameter("F_ClaDoc") + "','" + request.getParameter("F_ClaDoc") + "','" + rset.getString("F_ClaOrg") + "','" + sesion.getAttribute("nombre") + "','2','1')";
                            System.out.println(qry);
                            try {
                                //Se inserta en la tabla de tb_compratemp los datos de la remisión
                                conSendero.insertar(qry);
                            } catch (Exception e) {
                                System.out.println(e.getMessage());
                            }
                        }
                        conSendero.cierraConexion();
                        con.cierraConexion();
                        response.sendRedirect("reimp_factura.jsp");
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
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
