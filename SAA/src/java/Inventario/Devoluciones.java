/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Inventario;

import ISEM.NuevoISEM;
import conn.ConectionDB;
import conn.ConectionDB_SQLServer;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import servlets.Facturacion;

/**
 *
 * @author Americo
 */
public class Devoluciones extends HttpServlet {

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

        ConectionDB con = new ConectionDB();
        ConectionDB_SQLServer consql = new ConectionDB_SQLServer();
        Facturacion fact = new Facturacion();
        NuevoISEM objSql = new NuevoISEM();
        java.text.DateFormat df2 = new java.text.SimpleDateFormat("dd/MM/yyyy");
        java.text.DateFormat df3 = new java.text.SimpleDateFormat("yyyy-MM-dd");
        java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession sesion = request.getSession(true);
        try {
            try {
                if (request.getParameter("accion").equals("devolver")) {
                    con.conectar();
                    consql.conectar();
                    String ClaPro = "", Total = "", Ubicacion = "", Provee = "", FolLote = "", ClaLot = "", FecCad = "";
                    String FolLotSql = "";
                    int cantSQL = 0, cant = 0;
                    ResultSet rset = con.consulta("select * from tb_lote where F_IdLote = '" + request.getParameter("IdLote") + "'");
                    while (rset.next()) {
                        ClaPro = rset.getString("F_ClaPro");
                        cant = rset.getInt("F_ExiLot");
                        ClaLot = rset.getString("F_ClaLot");
                        FecCad = rset.getString("F_FecCad");
                        Ubicacion = rset.getString("F_Ubica");
                        Provee = rset.getString("F_ClaOrg");
                        FolLote = rset.getString("F_FolLot");

                    }
                    ResultSet rsetsql = consql.consulta("select F_FolLot, F_ExiLot from tb_lote where F_ClaLot = '" + ClaLot + "' and F_ClaPro= '" + ClaPro + "' and F_FecCad = '" + df2.format(df3.parse(FecCad)) + "' and F_ClaPrv = '" + Provee + "'");
                    while (rsetsql.next()) {
                        FolLotSql = rsetsql.getString("F_FolLot");
                        cantSQL = rsetsql.getInt("F_ExiLot");
                    }

                    double importe = devuelveImporte(ClaPro, cant);
                    double iva = devuelveIVA(ClaPro, cant);
                    double costo = devuelveCosto(ClaPro);
                    int ncant = cantSQL - cant;

                    String indMov = objSql.dameidMov();

                    con.insertar("insert into tb_movinv values('0',CURDATE(),'0','52','" + ClaPro + "','" + cant + "','" + costo + "','" + importe + "','-1','" + FolLote + "','" + Ubicacion + "','" + Provee + "',CURTIME(),'" + (String) sesion.getAttribute("nombre") + "')");
                    consql.insertar("insert into TB_MovInv values(CONVERT(date,GETDATE()),'1','','52','" + ClaPro + "','" + cant + "','"+costo+"','" + iva + "','" + importe + "','-1','" + FolLotSql + "','" + indMov + "','A','0','','','','" + Provee + "','" + (String) sesion.getAttribute("nombre") + "')");
                    con.insertar("update tb_lote set F_ExiLot = '0' where F_IdLote = '" + request.getParameter("IdLote") + "' ");
                    consql.insertar("update TB_Lote set F_ExiLot='" + ncant + "' where F_FolLot = '" + FolLotSql + "'");
                    consql.cierraConexion();
                    con.cierraConexion();
                    out.println("<script>alert('Devolucion Correcta')</script>");
                    out.println("<script>window.location='devolucionesInsumo.jsp'</script>");
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        } finally {
            out.close();
        }
    }

    double devuelveImporte(String clave, int cantidad) throws SQLException {

        ConectionDB con = new ConectionDB();
        int Tipo = 0;
        double Costo = 0.0, IVA = 0.0, Monto = 0.0, IVAPro = 0.0, MontoIva = 0.0;
        con.conectar();
        ResultSet rset = con.consulta("select F_TipMed, F_Costo from tb_medica where F_ClaPro = '" + clave + "'");
        while (rset.next()) {
            Tipo = rset.getInt(1);
            Costo = rset.getDouble(2);
        }
        if (Tipo == 2504) {
            IVA = 0.0;
        } else {
            IVA = 0.16;
        }
        IVAPro = (cantidad * Costo) * IVA;
        Monto = cantidad * Costo;
        MontoIva = Monto + IVAPro;
        con.cierraConexion();
        return MontoIva;
    }

    double devuelveIVA(String clave, int cantidad) throws SQLException {

        ConectionDB con = new ConectionDB();
        int Tipo = 0;
        double Costo = 0.0, IVA = 0.0, IVAPro = 0.0;
        con.conectar();
        ResultSet rset = con.consulta("select F_TipMed, F_Costo from tb_medica where F_ClaPro = '" + clave + "'");
        while (rset.next()) {
            Tipo = rset.getInt(1);
            Costo = rset.getDouble(2);
        }
        if (Tipo == 2504) {
            IVA = 0.0;
        } else {
            IVA = 0.16;
        }
        IVAPro = (cantidad * Costo) * IVA;
        con.cierraConexion();
        return IVAPro;
    }

    double devuelveCosto(String Clave) throws SQLException {
        ConectionDB con = new ConectionDB();
        double Costo = 0.0;
        con.conectar();
        ResultSet rset = con.consulta("select F_Costo from tb_medica where F_ClaPro = '" + Clave + "'");
        while (rset.next()) {
            Costo = rset.getDouble(1);
        }
        return Costo;

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
