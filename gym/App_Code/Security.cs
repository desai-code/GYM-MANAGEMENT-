using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Web;

/// <summary>Password hashing (PBKDF2 + random salt) with a fallback for old plain-text passwords.</summary>
public static class Security
{
    private const int Iterations = 10000;

    public static string HashPassword(string password)
    {
        byte[] salt = new byte[16];
        using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider()) rng.GetBytes(salt);
        byte[] hash = Derive(password, salt, Iterations);
        return "v1$" + Iterations + "$" + Convert.ToBase64String(salt) + "$" + Convert.ToBase64String(hash);
    }

    /// <summary>True if password matches. needsUpgrade = stored value was still plain text.</summary>
    public static bool Verify(string password, string stored, out bool needsUpgrade)
    {
        needsUpgrade = false;
        if (password == null || string.IsNullOrEmpty(stored)) return false;

        if (stored.StartsWith("v1$"))
        {
            string[] p = stored.Split('$');
            if (p.Length != 4) return false;
            int iter;
            if (!int.TryParse(p[1], out iter)) return false;
            byte[] salt, expected;
            try { salt = Convert.FromBase64String(p[2]); expected = Convert.FromBase64String(p[3]); }
            catch { return false; }
            return SlowEquals(Derive(password, salt, iter), expected);
        }

        // legacy plain-text password from the old version of the site
        bool ok = SlowEquals(System.Text.Encoding.UTF8.GetBytes(password), System.Text.Encoding.UTF8.GetBytes(stored));
        needsUpgrade = ok;
        return ok;
    }

    private static byte[] Derive(string password, byte[] salt, int iterations)
    {
        using (Rfc2898DeriveBytes kdf = new Rfc2898DeriveBytes(password, salt, iterations)) return kdf.GetBytes(20);
    }

    private static bool SlowEquals(byte[] a, byte[] b)
    {
        uint diff = (uint)a.Length ^ (uint)b.Length;
        for (int i = 0; i < a.Length && i < b.Length; i++) diff |= (uint)(a[i] ^ b[i]);
        return diff == 0;
    }
}

/// <summary>Very small brute-force guard: 5 failed logins per IP+area in 10 minutes => temporary block.</summary>
public static class LoginThrottle
{
    private const int MaxFails = 5;
    private static readonly TimeSpan Window = TimeSpan.FromMinutes(10);
    private static readonly Dictionary<string, List<DateTime>> Fails = new Dictionary<string, List<DateTime>>();

    private static string Key(string area)
    {
        string ip = HttpContext.Current != null ? HttpContext.Current.Request.UserHostAddress : "?";
        return area + "|" + ip;
    }

    public static bool IsBlocked(string area)
    {
        lock (Fails)
        {
            List<DateTime> l;
            if (!Fails.TryGetValue(Key(area), out l)) return false;
            l.RemoveAll(d => DateTime.UtcNow - d > Window);
            return l.Count >= MaxFails;
        }
    }

    public static void Fail(string area)
    {
        lock (Fails)
        {
            List<DateTime> l;
            if (!Fails.TryGetValue(Key(area), out l)) { l = new List<DateTime>(); Fails[Key(area)] = l; }
            l.Add(DateTime.UtcNow);
        }
    }

    public static void Reset(string area)
    {
        lock (Fails) Fails.Remove(Key(area));
    }
}
