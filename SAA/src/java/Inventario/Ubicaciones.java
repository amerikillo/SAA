/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Inventario;

import conn.ConectionDB;
import conn.ConectionDB_Modula;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Americo
 */
public class Ubicaciones extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * 
     * Servlet con las funciones que se utilizan en el proceso de redistribución
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        ConectionDB con = new ConectionDB();
        Devoluciones objDev = new Devoluciones();
        HttpSession sesion = request.getSession(true);
        try {
            try {
                /**
                 * Se llama cuando un insumo está apartado por algun Concentrado Global 
                 * sin embargo ya no se remisionará.
                 * 
                 */
                if (request.getParameter("accion").equals("eliminarFactTemp")) {
                    try {
                        con.conectar();
                        con.insertar("delete from tb_facttemp where F_Id='" + request.getParameter("F_Id") + "'");
                        con.cierraConexion();
                    } catch (Exception e) {
                    }
                }
                /**
                 * Manda llamar el método 'Reubica' de redistribución en almacén
                 */
                if (request.getParameter("accion").equals("Redistribucion")) {
                    
                    int nIdLote = Reubica(request.getParameter("F_IdLote"), request.getParameter("F_ClaUbi"), request.getParameter("CantMov"), (String) sesion.getAttribute("nombre"));
                    //ReubicaApartado(request.getParameter("F_IdLote"), nIdLote);
                    response.sendRedirect("hh/insumoNuevoRedist.jsp");
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        } finally {
            out.close();
        }
    }
    
    /**
     * 
     * @param idLote
     * @param CBUbica
     * @param cantMov
     * @param Nombre
     * @return
     * @throws SQLException 
     * 
     * Para reubicar en almacén
     */
    public int Reubica(String idLote, String CBUbica, String cantMov, String Nombre) throws SQLException {
        int idLoteNuevo = 0;
        Devoluciones objDev = new Devoluciones();
        ConectionDB con = new ConectionDB();
        ConectionDB_Modula conModula = new ConectionDB_Modula();
        con.conectar();
        String UbicaMov = CBUbica;
        DateFormat df = new SimpleDateFormat("yyyyMMddhhmmss");
        DateFormat df2 = new SimpleDateFormat("yyyyMMdd");
        DateFormat df3 = new SimpleDateFormat("yyyy-MM-dd");
        int CantMov = Integer.parseInt(cantMov);
        String F_ClaPro = "", F_ClaLot = "", F_FecCad = "", F_FolLot = "", F_ClaOrg = "", F_Ubica = "", F_FecFab = "", F_Cb = "", F_ClaMar = "";
        int F_ExiLot = 0, F_IdLote = 0, F_ExiLotDestino = 0;
        
        /**
         * Se obtienen los datos del insumo a reubicar
         */
        ResultSet rset = con.consulta("select * from tb_lote where F_IdLote = '" + idLote + "' ");
        while (rset.next()) {
            F_ClaPro = rset.getString("F_ClaPro");
            F_ClaLot = rset.getString("F_ClaLot");
            F_FecCad = rset.getString("F_FecCad");
            F_FolLot = rset.getString("F_FolLot");
            F_ClaOrg = rset.getString("F_ClaOrg");
            F_Ubica = rset.getString("F_Ubica");
            F_FecFab = rset.getString("F_FecFab");
            F_Cb = rset.getString("F_Cb");
            F_ClaMar = rset.getString("F_ClaMar");
            F_ExiLot = rset.getInt("F_ExiLot");
        }
        
        /**
         * Se obtiene la nueva ubicación a mover con base en su CB
         * 
         */
        
        rset = con.consulta("select F_ClaUbi from tb_ubica where F_Cb= '" + CBUbica + "' ");
        while (rset.next()) {
            UbicaMov = rset.getString("F_ClaUbi");
        }
        
        /**
         * Se obtiene el ID del lote y la cantidad de la ubicación destino, co nbase en clave lote caducidad y ubicación a donde se moverá
         * 
         */
        rset = con.consulta("select F_IdLote, F_ExiLot from tb_lote where F_ClaPro= '" + F_ClaPro + "' and F_ClaLot = '" + F_ClaLot + "' and F_FecCad = '" + F_FecCad + "' and F_Ubica = '" + UbicaMov + "' ");
        while (rset.next()) {
            F_ExiLotDestino = rset.getInt("F_ExiLot");
            F_IdLote = rset.getInt("F_IdLote");
        }
        
        /**
         * Para que no se generen negativos
         */
        if (F_ExiLot - CantMov >= 0) {
            if (F_IdLote != 0) {//Ya existe insumo en el desitno
                con.insertar("update tb_lote set F_ExiLot = '" + (F_ExiLotDestino + CantMov) + "' where F_IdLote='" + F_IdLote + "'");
                if (CBUbica.equals("MODULA")) {
                    conModula.conectar();
                    conModula.ejecutar("insert into IMP_AVVISIINGRESSO (RIG_OPERAZIONE, RIG_ARTICOLO, RIG_SUB1, RIG_SUB2, RIG_QTAR, RIG_DSCAD, RIG_REQ_NOTE, RIG_ATTR1, RIG_ERRORE, RIG_HOSTINF) values('A','" + F_ClaPro + "','" + F_ClaLot + "','1','" + (CantMov) + "','" + F_FecCad.replace("-", "") + "','" + F_Cb + "','','','" + df.format(new Date()) + "')");
                    conModula.cierraConexion();
                }
            } else {//No existe insumo en el destino
                con.insertar("insert into tb_lote values(0,'" + F_ClaPro + "','" + F_ClaLot + "','" + F_FecCad + "','" + CantMov + "','" + F_FolLot + "','" + F_ClaOrg + "','" + UbicaMov + "','" + F_FecFab + "','" + F_Cb + "','" + F_ClaMar + "')");
                if (CBUbica.equals("MODULA")) {
                    conModula.conectar();
                    conModula.ejecutar("insert into IMP_AVVISIINGRESSO  (RIG_OPERAZIONE, RIG_ARTICOLO, RIG_SUB1, RIG_SUB2, RIG_QTAR, RIG_DSCAD, RIG_REQ_NOTE, RIG_ATTR1, RIG_ERRORE, RIG_HOSTINF) values('A','" + F_ClaPro + "','" + F_ClaLot + "','1','" + (CantMov) + "','" + F_FecCad.replace("-", "") + "','" + F_Cb + "','','','" + df.format(new Date()) + "')");
                    conModula.cierraConexion();
                }
            }
            
            /**
             * Se actualiza la existencia de la antigua ubicación 
             */
            con.insertar("update tb_lote set F_ExiLot = '" + (F_ExiLot - CantMov) + "' where F_IdLote = '" + idLote + "' ");
            
            
            /**
             * Inserción de los movimientos
             */
            con.insertar("insert into tb_movinv values (0,CURDATE(),'0','1000','" + F_ClaPro + "','" + CantMov + "','" + objDev.devuelveCosto(F_ClaPro) + "','" + objDev.devuelveImporte(F_ClaPro, CantMov) + "', '-1','" + F_FolLot + "','" + F_Ubica + "','" + F_ClaOrg + "',CURTIME(),'" + Nombre + "')");
            con.insertar("insert into tb_movinv values (0,CURDATE(),'0','1000','" + F_ClaPro + "','" + CantMov + "','" + objDev.devuelveCosto(F_ClaPro) + "','" + objDev.devuelveImporte(F_ClaPro, CantMov) + "', '1','" + F_FolLot + "','" + UbicaMov + "','" + F_ClaOrg + "',CURTIME(),'" + Nombre + "')");
            
            
            rset = con.consulta("select F_IdLote from tb_lote where F_FolLot = '" + F_FolLot + "' and F_Ubica = '" + UbicaMov + "' ");
            while (rset.next()) {
                idLoteNuevo = rset.getInt("F_IdLote");
            }
        }
        con.cierraConexion();
        return idLoteNuevo;
    }
    
    
    /**
     * Método que se utilizaría para reubicar insumo previamente apartado, por cuestiones operativas no se ocupa.
     * @param idLote
     * @param nidLote
     * @throws SQLException 
     */
    public void ReubicaApartado(String idLote, int nidLote) throws SQLException {
        ConectionDB con = new ConectionDB();
        con.conectar();
        ResultSet rset = con.consulta("select * from tb_facttemp where F_IdLot='" + idLote + "' and F_StsFact <5");
        while (rset.next()) {
            int cantFact = rset.getInt("F_Cant");
            int cantLote = 0;
            int cantApartada = 0;
            ResultSet rset2 = con.consulta("select F_ExiLot from tb_lote where F_IdLote = '" + idLote + "' ");
            while (rset2.next()) {
                cantLote = rset2.getInt(1);
            }
            rset2 = con.consulta("select sum(F_Cant) from tb_facttemp where F_IdLot = '" + idLote + "' and F_Id<'" + rset.getString("F_Id") + "' and F_StsFact<5 group by F_IdLot");
            while (rset2.next()) {
                cantApartada = rset2.getInt(1);
            }
            System.out.println(cantLote + "-" + cantApartada);
            cantLote = cantLote - cantApartada;
            System.out.println(cantFact + "-" + cantLote);
            int diferencia = cantFact - cantLote;
            System.out.println(diferencia + "/////Diferencia");
            
            if (diferencia > 0) {
                int F_Id = 0, CantAnt = 0;
                con.insertar("update tb_facttemp set F_Cant = '" + cantLote + "' where F_Id= '" + rset.getString("F_Id") + "' ");
                rset2 = con.consulta("select F_Id, F_Cant from tb_facttemp where F_IdLot = '" + nidLote + "' and F_IdFact = '" + rset.getString("F_IdFact") + "' ");
                while (rset2.next()) {
                    F_Id = rset2.getInt("F_Id");
                    CantAnt = rset2.getInt("F_Cant");
                }
                if (F_Id != 0) {
                    con.insertar("update tb_facttemp set F_Cant='" + (diferencia + CantAnt) + "' where F_Id='" + F_Id + "'");
                } else {
                    con.insertar("insert into tb_facttemp values ('" + rset.getString("F_IdFact") + "','" + rset.getString("F_ClaCli") + "','" + nidLote + "','" + diferencia + "','" + rset.getString("F_FecEnt") + "','" + rset.getString("F_StsFact") + "',0,'" + rset.getString("F_User") + "')");
                }
            }
            
        }
        con.cierraConexion();
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
