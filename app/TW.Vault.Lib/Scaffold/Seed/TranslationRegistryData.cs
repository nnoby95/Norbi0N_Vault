using System.Collections.Generic;

namespace TW.Vault.Lib.Scaffold.Seed
{
    public static class TranslationRegistryData
    {
        public static List<TranslationRegistry> Contents { get; } = new List<TranslationRegistry>
        {
            new TranslationRegistry { Id = 1, Name = "Default", Author = "tcamps", AuthorPlayerId = 11301059, LanguageId = 1, IsSystemInternal = false },
            new TranslationRegistry { Id = 2, Name = "Hungarian", Author = "Norbi0N", AuthorPlayerId = 0, LanguageId = 2, IsSystemInternal = false }
        };
    }
}