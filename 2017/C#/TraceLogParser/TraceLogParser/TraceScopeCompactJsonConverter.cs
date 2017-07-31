using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace TraceLogParser
{
    /// <summary>
    /// In order to avoid adding long string key into a dictionary does a custom serializer
    /// That will only create a temporary string object just before it is needed for serialization
    /// </summary>
    public class TraceScopeCompactJsonConverter : JsonConverter
    {
        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            var scope = value as TraceScopeCompact;
            if (scope == null) return;

            writer.WriteStartObject();
            foreach (KeyValuePair<TraceScope, TraceScopeCompact> subScope in scope)
            {
                TraceScope traceScope = subScope.Key;
                writer.WritePropertyName($"{traceScope.Time:HH:mm:ss:ms} [{(traceScope.Duration == -1 ? "?" : traceScope.Duration.ToString())} ms] {traceScope.ActorString}:{traceScope.ActionString} @{traceScope.Unique}");

                TraceScopeCompact traceScopeCompact = subScope.Value;
                serializer.Serialize(writer, traceScopeCompact);
            }
            writer.WriteEndObject();
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            throw new NotImplementedException();
        }

        public override bool CanConvert(Type objectType)
        {
            return true;
        }
    }
}