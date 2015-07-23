/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Facturacion;

import conn.ConectionDB;
import conn.ConectionDB_CedisSendero;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

/**
 *
 * @author linux9
 */
public class EnviarCedisSendero extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * 
     * Para enviar muchas remisiones al CEDIS SENDERO
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession sesion = request.getSession();
        ConectionDB con = new ConectionDB();
        ConectionDB_CedisSendero conSendero = new ConectionDB_CedisSendero();
        /**
         * Se obtienen los folios de remision a enviar a sendero
         */
        ArrayList<String> listEnvSen;
        try {
            if (request.getParameter("que").equals("add")) {
                if (sesion.getAttribute("listEnvSen") == null) {
                    listEnvSen = new ArrayList<String>();
                } else {
                    try {
                        listEnvSen = (ArrayList<String>) sesion.getAttribute("listEnvSen");
                    } catch (Exception ex) {
                        System.out.println("Exception rara" + ex + "->" + sesion.getAttribute("listEnvSen"));
                        listEnvSen = new ArrayList<String>();
                    }
                }
                listEnvSen.add(request.getParameter("id"));
                sesion.setAttribute("listEnvSen", listEnvSen);
                System.out.println(listEnvSen);
            } else if ("rem".equals(request.getParameter("que"))) {
                listEnvSen = (ArrayList<String>) sesion.getAttribute("listEnvSen");
                String id = request.getParameter("id");
                for (String list1 : listEnvSen) {
                    if (id.equals(list1)) {
                        listEnvSen.remove(list1);
                        System.out.println("nuevo->" + listEnvSen);
                        break;
                    }
                }
            } else if ("g".equals(request.getParameter("que"))) {
                //Se envian las múltiples remisiones al Distribuidor
                try {
                    listEnvSen = (ArrayList<String>) sesion.getAttribute("listEnvSen");
                    System.out.println("->"+listEnvSen);
                    con.conectar();
                    conSendero.conectar();
                    for (String list1 : listEnvSen) {
                        ResultSet rset = con.consulta("SELECT U.F_NomCli,DATE_FORMAT(F.F_FecEnt,'%d/%m/%Y') AS F_FecEnt,F.F_ClaDoc,F.F_ClaPro,M.F_DesPro,L.F_ClaLot,L.F_FecCad,(F.F_CantSur) as surtido,(F.F_CantReq) as requerido,F.F_Costo,(F.F_Monto) as importe, F.F_Ubicacion, L.F_ClaOrg, L.F_Cb, L.F_ClaMar, L.F_FecFab FROM tb_factura F INNER JOIN tb_medica M ON F.F_ClaPro=M.F_ClaPro INNER JOIN tb_lote L ON F.F_Lote=L.F_FolLot INNER JOIN tb_uniatn U ON F.F_ClaCli=U.F_ClaCli WHERE F.F_ClaDoc='" + list1 + "' and F_StsFact='A' GROUP BY F.F_IdFact");
                        while (rset.next()) {
                            double impuesto = 0.0;
                            impuesto = rset.getDouble("F_Costo") * rset.getDouble("surtido");
                            String qry = "insert into tb_compratemp values ('0',CURDATE(),'" + rset.getString("F_ClaPro") + "','" + rset.getString("F_ClaLot") + "','" + rset.getString("F_FecCad") + "','" + rset.getString("F_FecFab") + "','" + rset.getString("F_ClaMar") + "','" + rset.getString("F_ClaOrg") + "','" + rset.getString("F_Cb") + "','1','1','" + rset.getString("surtido") + "','0','0','0','" + rset.getString("F_Costo") + "','" + impuesto + "','" + rset.getString("importe") + "','Se envía desde SAA CC','" + list1 + "','" + list1 + "','" + rset.getString("F_ClaOrg") + "','" + sesion.getAttribute("nombre") + "','2','1')";
                            System.out.println(qry);
                            try {
                                conSendero.insertar(qry);
                            } catch (Exception e) {
                                System.out.println(e.getMessage());
                            }
                        }
                    }
                    sesion.setAttribute("listEnvSen", null);
                    conSendero.cierraConexion();
                    con.cierraConexion();
                    response.sendRedirect("reimp_factura.jsp");
                } catch (Exception ex) {
                    System.out.println("ErrorG->" + ex);
                }
            }else if ("b".equals(request.getParameter("que"))) {
                sesion.setAttribute("fIniRF", request.getParameter("fIni"));
                sesion.setAttribute("fFinRF", request.getParameter("fFin"));
                sesion.setAttribute("whereRF","WHERE F.F_FecEnt BETWEEN '"+request.getParameter("fIni")+"' AND '"+request.getParameter("fFin")+"'");
            }else if ("r".equals(request.getParameter("que"))) {
                sesion.setAttribute("whereRF",null);
                sesion.setAttribute("fIniRF", null);
                sesion.setAttribute("fFinRF", null);
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
