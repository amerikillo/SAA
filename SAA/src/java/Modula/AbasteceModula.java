/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Modula;

import ISEM.NuevoISEM;
import conn.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import servlets.Facturacion;
import Facturacion.FacturacionManual;
import Inventario.Devoluciones;
import java.sql.SQLException;

/**
 *
 * @author Americo
 */
public class AbasteceModula extends HttpServlet {

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
        ConectionDB con = new ConectionDB();
        ConectionDB_SQLServer conModula = new ConectionDB_SQLServer();
        FacturacionManual factObj = new FacturacionManual();
        Devoluciones objDev = new Devoluciones();
        //ConectionDB_SQLServer consql = new ConectionDB_SQLServer();
        Facturacion fact = new Facturacion();
        NuevoISEM objSql = new NuevoISEM();
        java.text.DateFormat df2 = new java.text.SimpleDateFormat("dd/MM/yyyy");
        java.text.DateFormat df3 = new java.text.SimpleDateFormat("yyyy-MM-dd");
        java.text.DateFormat df4 = new java.text.SimpleDateFormat("yyyyMMdd");
        java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession(true);
        try {
            try {
                if (!request.getParameter("accionEliminar").equals("")) {
                    con.conectar();
                    con.insertar("delete from tb_abasmodtemp where F_Id = '" + request.getParameter("accionEliminar") + "' ");
                    con.cierraConexion();
                    out.println("<script>alert('Clave Eliminada Correctamente')</script>");
                    out.println("<script>window.location='modula/cargaInsumo.jsp'</script>");
                }
            } catch (Exception e) {
            }
            try {
                if (request.getParameter("accion").equals("CargarAbasto")) {
                    int ini = 0, fin = 0;
                    //Generar archivo para abasto de Modula
                    //Partir cantidad en caso de que sea menor al total en el ID
                    try {
                        con.conectar();
                        ResultSet rset = con.consulta("SELECT l.F_ClaPro, l.F_ClaLot, l.F_FecCad, m.F_DesPro, u.F_DesUbi, a.F_Cant, a.F_Id, a.F_IdLote, l.F_ExiLot,l.F_ClaMar, l.F_FolLot, l.F_Cb, l.F_Ubica, l.F_FecFab, l.F_ClaOrg from tb_abasmodtemp a, tb_lote l, tb_medica m, tb_ubica u WHERE a.F_IdLote=l.F_IdLote and l.F_ClaPro = m.F_ClaPro and l.F_Ubica = u.F_ClaUbi and a.F_Usuario='" + sesion.getAttribute("nombre") + "' and a.F_Sts=0;");
                        while (rset.next()) {
                            String ClaPro = rset.getString("F_ClaPro");
                            String ClaLot = rset.getString("F_ClaLot");
                            String FecCad = rset.getString("F_FecCad");
                            String FolLot = rset.getString("F_FolLot");
                            String Ubica = rset.getString("F_Ubica");
                            String Provee = rset.getString("F_ClaOrg");
                            String FecFab = rset.getString("F_FecFab");
                            String Marca = rset.getString("F_ClaMar");
                            String CB = rset.getString("F_Cb");
                            int cantMod = rset.getInt("F_Cant");
                            String idLote = rset.getString("F_IdLote");
                            int cantLote = rset.getInt("F_ExiLot");

                            double costo = objDev.devuelveCosto(ClaPro);
                            double importe = objDev.devuelveImporte(ClaPro, cantMod);
                            String idLoteMod = "0";
                            int CantAnterior = 0;
                            con.insertar("insert into tb_movinv values(0,CURDATE(),0,'1001','" + ClaPro + "','" + cantMod + "','" + costo + "','" + importe + "','-1','" + FolLot + "','" + Ubica + "','" + Provee + "',CURTIME(),'" + sesion.getAttribute("nombre") + "')");
                            con.insertar("insert into tb_movinv values(0,CURDATE(),0,'1001','" + ClaPro + "','" + cantMod + "','" + costo + "','" + importe + "','1','" + FolLot + "','MODULA','" + Provee + "',CURTIME(),'" + sesion.getAttribute("nombre") + "')");

                            ResultSet rset2 = con.consulta("select F_IdLote, F_ExiLot from tb_lote where F_Ubica = 'MODULA' and F_FolLot='" + FolLot + "'");
                            while (rset2.next()) {
                                idLoteMod = rset2.getString("F_IdLote");
                                CantAnterior = rset2.getInt("F_ExiLot");
                            }
                            //Existe el insumo en tb_lote con MODULA
                            if (!idLoteMod.equals("0")) {
                                con.insertar("update tb_lote set F_ExiLot = '" + (CantAnterior + cantMod) + "' where F_IdLote = '" + idLoteMod + "'");
                            } else {
                                //SI no existe
                                con.insertar("insert into tb_lote values (0,'" + ClaPro + "','" + ClaLot + "','" + FecCad + "','" + (cantMod) + "','" + objDev.devuelveIndLote() + "','" + Provee + "','MODULA','" + FecFab + "','" + CB + "','" + Marca + "')");
                            }
                            con.insertar("update tb_lote set F_ExiLot = '" + (cantLote - cantMod) + "' where F_IdLote='" + idLote + "' ");
                            con.insertar("update tb_abasmodtemp set F_Sts=1 where F_Id='" + rset.getInt("F_Id") + "' ");
                        }
                        rset.first();
                        ini = rset.getInt("F_Id");
                        rset.last();
                        fin = rset.getInt("F_Id");
                        con.cierraConexion();
                    } catch (SQLException e) {
                        System.out.println(e.getMessage());
                    }

                    out.println("<script>window.open('modula/gnrAbastoModula.jsp?ini=" + ini + "&fin=" + fin + "', '', 'width=1200,height=800,left=50,top=50,toolbar=no')</script>");
                    out.println("<script>window.location='modula/cargaInsumo.jsp'</script>");
                    //response.sendRedirect("modula/gnrAbastoModula.jsp");
                }
                if (request.getParameter("accion").equals("btnClave")) {
                    try {
                        String F_IndGlobal = (String) sesion.getAttribute("F_IndGlobal");
                        if (F_IndGlobal == null) {
                            sesion.setAttribute("F_IndGlobal", factObj.dameIndGlobal() + "");
                            F_IndGlobal = (String) sesion.getAttribute("F_IndGlobal");
                        }
                        con.conectar();
                        ResultSet rset = con.consulta("select m.F_ClaPro, m.F_DesPro, l.F_ClaLot, l.F_FolLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') from tb_medica m, tb_lote l where m.F_ClaPro = l.F_ClaPro and m.F_ClaPro = '" + request.getParameter("ClaPro") + "' group by m.F_ClaPro;");
                        while (rset.next()) {
                            sesion.setAttribute("DesProFM", rset.getString(2));
                        }
                        con.cierraConexion();
                        sesion.setAttribute("ClaCliFM", request.getParameter("ClaCli"));
                        sesion.setAttribute("FechaEntFM", request.getParameter("FechaEnt"));
                        sesion.setAttribute("ClaProFM", request.getParameter("ClaPro"));
                        response.sendRedirect("modula/cargaInsumo.jsp");
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                }

                if (request.getParameter("accion").equals("SeleccionaLote")) {
                    System.out.println(request.getParameter("Cantidad"));
                    response.setContentType("text/html");
                    request.setAttribute("Cantidad", request.getParameter("Cantidad"));
                    request.getRequestDispatcher("modula/abasteceModulaSelecLote.jsp").forward(request, response);
                }

                if (request.getParameter("accion").equals("AgregarClave")) {
                    try {
                        con.conectar();
                        con.insertar("insert into tb_abasmodtemp values('0','" + request.getParameter("IdLot") + "','" + request.getParameter("Cant") + "',0, NOW(), '" + sesion.getAttribute("nombre") + "' )");
                        con.cierraConexion();
                        response.sendRedirect("modula/cargaInsumo.jsp");
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                }

                if (request.getParameter("accion").equals("AbastecerConcentrado")) {
                    con.conectar();
                    conModula.conectar();
                    try {
                        ResultSet rset = con.consulta("select F_ClaPro, F_ClaLot, F_FecCad, F_CB, F_Ori, F_Cant, F_Id from tb_concentradomodula where F_Sts=0");
                        while (rset.next()) {
                            /*
                             * La 'I' es de inserción
                             */
                            conModula.ejecutar("insert into IMP_AVVISIINGRESSO values('A','" + rset.getString("F_ClaPro") + "','" + rset.getString("F_ClaLot") + "','" + rset.getString("F_Ori") + "','" + rset.getString("F_Cant") + "','" + df4.format(df3.parse(rset.getString("F_FecCad"))) + "','" + rset.getString("F_CB") + "','','')");
                            con.insertar("update tb_concentradomodula set F_Sts='1' where F_Id='" + rset.getString("F_Id") + "'");
                        }

                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                    conModula.cierraConexion();
                    con.cierraConexion();
                    response.sendRedirect("modula/conexionModula.jsp");
                }
                if (request.getParameter("accion").equals("MandaRequerimento")) {
                    con.conectar();
                    conModula.conectar();
                    try {

                        ResultSet rset = con.consulta("select F_ClaCli, F_FecEnt, F_FolRemi from tb_reqmodula where F_Sts=0 group by F_FolRemi");
                        while (rset.next()) {
                            conModula.ejecutar("insert into IMP_ORDINI values ('" + rset.getString("F_FolRemi") + "','A','','" + df4.format(df3.parse(rset.getString("F_FecEnt"))) + "','P','" + rset.getString("F_ClaCli") + "','1')");
                        }
                        rset = con.consulta("select F_ClaCli, F_FecEnt, F_FolRemi, F_ClaPro, F_ClaLot, F_FecCad, F_CB, F_Ori, F_Cant, F_Id from tb_reqmodula where F_Sts=0");
                        while (rset.next()) {
                            /*
                             * La 'A' es de inserción
                             */
                            conModula.ejecutar("insert into IMP_ORDINI_RIGHE values('" + rset.getString("F_FolRemi") + "','','" + rset.getString("F_ClaPro") + "','" + rset.getString("F_ClaLot") + "','" + rset.getString("F_Ori") + "','" + rset.getString("F_Cant") + "','" + rset.getString("F_CB") + "','" + df4.format(df3.parse(rset.getString("F_FecCad"))) + "','')");
                            con.insertar("update tb_reqmodula set F_Sts='1' where F_Id='" + rset.getString("F_Id") + "'");
                        }

                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                    conModula.cierraConexion();
                    con.cierraConexion();
                    response.sendRedirect("modula/requerimentoModula.jsp");

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
