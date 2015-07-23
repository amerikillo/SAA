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
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author linux9
 */
public class DevolucionMultiple extends HttpServlet {

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
        PrintWriter out = response.getWriter();
        HttpSession sesion = request.getSession();
        ConectionDB con = new ConectionDB();
        ArrayList<String> listId;
        String lista = "";
        try {
            /**
             * Para agregar claves de la devolución multiple
             */
            if (request.getParameter("que").equals("add")) {
                if (sesion.getAttribute("listId") == null) {
                    listId = new ArrayList<String>();
                } else {
                    try {
                        listId = (ArrayList<String>) sesion.getAttribute("listId");
                    } catch (Exception ex) {
                        System.out.println("Exception rara" + ex + "->" + sesion.getAttribute("listId"));
                        listId = new ArrayList<String>();
                    }
                }

                try {
                    con.conectar();
                    ResultSet rs = con.consulta("SELECT U.F_NomCli,DATE_FORMAT(F.F_FecEnt,'%d/%m/%Y') AS F_FecEnt,F.F_ClaDoc,F.F_ClaPro,M.F_DesPro,L.F_ClaLot,DATE_FORMAT(L.F_FecCad,'%d/%m/%Y') AS F_FecCad,F.F_CantReq,F.F_CantSur,F.F_Costo,F.F_Monto, F.F_Ubicacion, F.F_IdFact FROM tb_factura F INNER JOIN tb_medica M ON F.F_ClaPro=M.F_ClaPro INNER JOIN tb_lote L ON F.F_Lote=L.F_FolLot INNER JOIN tb_uniatn U ON F.F_ClaCli=U.F_ClaCli WHERE"
                            + " F.F_ClaDoc='" + request.getParameter("folio") + "' and F.F_IdFact='" + request.getParameter("id") + "' GROUP BY F.F_IdFact");
                    System.out.println("id " + request.getParameter("id"));
                    System.out.println("fol " + request.getParameter("folio"));
                    if (rs.next()) {
                        listId.add(rs.getString(13));
                        sesion.setAttribute("folioM", rs.getString(3));
                        sesion.setAttribute("idM", rs.getString(13));
                        sesion.setAttribute("listId", listId);
                        System.out.println(listId);
                        for (String list1 : listId) {
                            ResultSet rs2 = con.consulta("SELECT U.F_NomCli,DATE_FORMAT(F.F_FecEnt,'%d/%m/%Y') AS F_FecEnt,F.F_ClaDoc,F.F_ClaPro,M.F_DesPro,L.F_ClaLot,DATE_FORMAT(L.F_FecCad,'%d/%m/%Y') AS F_FecCad,F.F_CantReq,F.F_CantSur,F.F_Costo,F.F_Monto, F.F_Ubicacion, F.F_IdFact FROM tb_factura F INNER JOIN tb_medica M ON F.F_ClaPro=M.F_ClaPro INNER JOIN tb_lote L ON F.F_Lote=L.F_FolLot INNER JOIN tb_uniatn U ON F.F_ClaCli=U.F_ClaCli WHERE"
                                    + " F.F_ClaDoc='" + request.getParameter("folio") + "' and F.F_IdFact='" + list1 + "' GROUP BY F.F_IdFact");
                            if (rs2.next()) {
                                lista += "<div class=\"row\">\n"
                                        + "<div class=\"col-sm-2\"><label>Clave: </label>" + rs2.getString(4) + "</div>\n"
                                        + "<div class=\"col-sm-7\"><label>Descripción: </label>" + rs2.getString(5) + "</div>\n"
                                        + "<div class=\"col-sm-3\"><label>Cantidad a devolver:</label>" + rs2.getString(9) + "</div>\n"
                                        + "</div>";
                            }
                        }
                        sesion.setAttribute("list", lista);
                    }
                    con.cierraConexion();
                } catch (SQLException ex) {
                    System.out.println("ErrorAdd->" + ex);
                }
            } else if ("rem".equals(request.getParameter("que"))) {
                listId = (ArrayList<String>) sesion.getAttribute("listId");
                String id = request.getParameter("id");
                String folio = request.getParameter("folio");
                for (String list1 : listId) {
                    if (id.equals(list1)) {
                        listId.remove(list1);
                        System.out.println("nuevo->" + listId);
                        break;
                    }
                }
                try {
                    for (String list1 : listId) {
                        con.conectar();
                        ResultSet rs2 = con.consulta("SELECT U.F_NomCli,DATE_FORMAT(F.F_FecEnt,'%d/%m/%Y') AS F_FecEnt,F.F_ClaDoc,F.F_ClaPro,M.F_DesPro,L.F_ClaLot,DATE_FORMAT(L.F_FecCad,'%d/%m/%Y') AS F_FecCad,F.F_CantReq,F.F_CantSur,F.F_Costo,F.F_Monto, F.F_Ubicacion, F.F_IdFact FROM tb_factura F INNER JOIN tb_medica M ON F.F_ClaPro=M.F_ClaPro INNER JOIN tb_lote L ON F.F_Lote=L.F_FolLot INNER JOIN tb_uniatn U ON F.F_ClaCli=U.F_ClaCli WHERE"
                                + " F.F_ClaDoc='" + folio + "' and F.F_IdFact='" + list1 + "' GROUP BY F.F_IdFact");
                        if (rs2.next()) {
                            lista += "<div class=\"row\">\n"
                                    + "<div class=\"col-sm-2\"><label>Clave: </label>" + rs2.getString(4) + "</div>\n"
                                    + "<div class=\"col-sm-7\"><label>Descripción: </label>" + rs2.getString(5) + "</div>\n"
                                    + "<div class=\"col-sm-3\"><label>Cantidad a devolver:</label>" + rs2.getString(9) + "</div>\n"
                                    + "</div>";
                        }
                    }
                } catch (SQLException ex) {
                    System.out.println("ErrorRM->" + ex);
                }
                sesion.setAttribute("list", lista);
            } else if ("g".equals(request.getParameter("que"))) {
                String mensaje = "Devoluciones:\n";
                try {
                    listId = (ArrayList<String>) sesion.getAttribute("listId");
                    byte[] a = request.getParameter("ObserM").getBytes("ISO-8859-1");
                    String Observaciones = (new String(a, "UTF-8")).toUpperCase();
                    String F_IdFact = "";
                    con.conectar();
                    for (String list1 : listId) {
                        con.actualizar("update tb_factura set F_StsFact = 'C', F_Obs='" + Observaciones + "' where F_IdFact = '" + list1 + "'");
                        ResultSet rsetfact = con.consulta("select * from tb_factura where F_IdFact = '" + list1 + "' ");
                        while (rsetfact.next()) {
                            con.insertar("insert into tb_factdevol values ('" + rsetfact.getString(1) + "','" + rsetfact.getString(2) + "','" + rsetfact.getString(3) + "','" + rsetfact.getString(4) + "','" + rsetfact.getString(5) + "','" + rsetfact.getString(6) + "','" + rsetfact.getString(7) + "','" + rsetfact.getString(8) + "','" + rsetfact.getString(9) + "','" + rsetfact.getString(10) + "','" + rsetfact.getString(11) + "','" + rsetfact.getString(12) + "','" + rsetfact.getString(13) + "','" + rsetfact.getString(14) + "','" + rsetfact.getString(15) + "','" + rsetfact.getString(16) + "','" + rsetfact.getString(17) + "',0) ");
                            if (list1.equals(listId.get(listId.size() - 1))) {
                                F_IdFact += list1;
                            } else {
                                F_IdFact += list1 + ",";
                            }

                        }
                    }

                    ResultSet rsetfact = con.consulta("select F_ClaPro, SUM(F_CantSur) from tb_factura where F_IdFact in (" + F_IdFact + ") and F_StsFact='C' group by F_ClaPro ");
                    while (rsetfact.next()) {
                        mensaje += "Clave: " + rsetfact.getString(1) + " Cantidad: " + rsetfact.getString(2) + "\n";
                    }
                    out.println("si|");
                    out.println(mensaje);
                    sesion.setAttribute("list", "");
                    sesion.setAttribute("listId", "");
                    con.cierraConexion();
                } catch (Exception ex) {
                    System.out.println("ErrorG->" + ex);
                    out.println("no");
                    sesion.setAttribute("list", "");
                    sesion.setAttribute("listId", null);
                }
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
