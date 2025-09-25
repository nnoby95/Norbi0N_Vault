
using System.Collections.Generic;

namespace TW.Vault.Lib.Scaffold.Seed
{
    public static class TranslationLanguageData
    {
        public static List<TranslationLanguage> Contents { get; } = new List<TranslationLanguage>
        {
            new TranslationLanguage { Id = 1, Name = "English" },
            new TranslationLanguage { Id = 2, Name = "Hungarian" },
        };
    }
}