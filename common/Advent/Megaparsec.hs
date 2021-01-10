module Advent.Megaparsec (
    Parser, readParsedLines, parseLines, parseWrapper,

    (<|>),                                                                   -- Control.Applicative
    ($>),                                                                    -- Data.Functor
    try, sepBy, endBy, many, optional, some, oneOf, manyTill, lookAhead,     -- Text.Megaparsec
    char, string, letterChar, alphaNumChar,                                  -- Text.Megaparsec.Char
    decimal                                                                  -- Text.Megaparsec.Char.Lexer
) where

import AdventAPI (readInputDefaults)
import Control.Applicative ((<|>))
import Data.Functor (($>))
import Data.Void (Void)
import Text.Megaparsec (Parsec, parse, eof, try, lookAhead, sepBy, endBy, many, manyTill, optional, some, oneOf)
import Text.Megaparsec.Char (char, string, letterChar, alphaNumChar)
import Text.Megaparsec.Char.Lexer (decimal)
import Text.Megaparsec.Error (errorBundlePretty)

type Parser a = Parsec Void String a

-- | Read the input of the given day and apply the given
-- parser to all lines of said input
readParsedLines :: Int -> Int -> Parser a -> IO [a]
readParsedLines year day parser = do
    input <- readInputDefaults year day
    return $ parseLines parser input

-- | Apply the given parser to all lines of said input
parseLines :: Parser a -> String -> [a]
parseLines parser input =
    let parserFull = parser `endBy` char '\n' <* eof
    in parseWrapper parserFull input

-- | Apply the given parser to the given input. Manages
-- error reporting.
parseWrapper :: Parser a -> String -> a
parseWrapper parser input =
    case parse parser "" input of
        Left e  -> error $ "\n" ++ errorBundlePretty e
        Right r -> r