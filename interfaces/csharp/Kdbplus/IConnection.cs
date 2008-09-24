using System;

namespace Kdbplus
{
    /// <summary>
    /// This is the interface for accessing kdb+ services remotely. 
    /// </summary>
    /// 
    /// <remarks>
    /// You can do three basic things against a kdb+ server:
    /// <list type="bullet">
    ///     <item><description>Run command strings where you expect no response</description></item>
    ///     <item><description>Run query strings where you expect some response</description></item>
    ///     <item><description>Listen for an unprompted incoming message</description></item>
    /// </list>
    /// </remarks>
    public interface IConnection : IDisposable
    {
        /// <summary>
        /// Waits for an incoming message from the kdb+ server.
        /// </summary>
        /// <returns>The message that was received.</returns>
        object Listen();
        
        /// <summary>
        /// Runs the given query string against the kdb+ server.
        /// </summary>
        /// <param name="query">The query string.</param>
        /// <returns>The result of the query.</returns>
        object Query(string query);
        
        /// <summary>
        /// Runs the given query string against the kdb+ server passing the
        /// parameter x.
        /// </summary>
        /// <param name="query">The query string.</param>
        /// <param name="x">The parameter x.</param>
        /// <returns>The result of the query.</returns>
        object Query(string query, object x);

        /// <summary>
        /// Runs the given query string against the kdb+ server passing the
        /// parameters x and y.
        /// </summary>
        /// <param name="query">The query string.</param>
        /// <param name="x">The parameter x.</param>
        /// <param name="y">The parameter y.</param>
        /// <returns>the result of the query.</returns>
        object Query(string query, object x, object y);

        /// <summary>
        /// Runs the given query string against the kdb+ server passing the
        /// parameters x, y, and z.
        /// </summary>
        /// <param name="query">The query string.</param>
        /// <param name="x">The parameter x.</param>
        /// <param name="y">The parameter y.</param>
        /// <param name="z">The parameter z.</param>
        /// <returns>The result of the query.</returns>
        object Query(string query, object x, object y, object z);
        
        /// <summary>
        /// Runs the given command string against the kdb+ server.
        /// </summary>
        /// <param name="command">The command string.</param>
        void Run(string command);

        /// <summary>
        /// Runs the given command string against the kdb+ server passing the
        /// parameter x.
        /// </summary>
        /// <param name="command">The command string.</param>
        /// <param name="x">The parameter x.</param>
        void Run(string command, object x);

        /// <summary>
        /// Runs the given command string against the kdb+ server passing the
        /// parameters x, and y.
        /// </summary>
        /// <param name="command">The query string.</param>
        /// <param name="x">The parameter x.</param>
        /// <param name="y">The parameter y.</param>
        void Run(string command, object x, object y);

        /// <summary>
        /// Runs the given command string against the kdb+ server passing the
        /// parameters x, y, and z.
        /// </summary>
        /// <param name="command">The query string.</param>
        /// <param name="x">The parameter x.</param>
        /// <param name="y">The parameter y.</param>
        /// <param name="z">The parameter z.</param>
        void Run(string command, object x, object y, object z);
    }
}