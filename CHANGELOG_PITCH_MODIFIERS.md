# CHANGELOG - gregorio.nvim v2.1

## Versão 2.1 - 2025-10-19

### 🎯 Pitch+Modifier Composite Descriptors

Implementação de padrões compostos que capturam a combinação `pitch+modifier` como uma unidade semântica, similar ao padrão usado para `su`/`pp` em snippets NABC.

#### Novos Padrões Implementados

1. **Pitch+Oriscus Descriptors** (`gabcPitchOriscusDescriptor`)
   - Padrão: `[a-npA-NP][oO][01]?`
   - Exemplos: `go`, `ho1`, `fO0`, `gO`
   - Componentes:
     * `gabcPitchOriscusBase`: letra de pitch (Identifier = azul claro)
     * `gabcPitchOriscusModifier`: o/O (Identifier = azul claro)
     * `gabcPitchOriscusSuffix`: 0 ou 1 (Number = verde brilhante)

2. **Pitch+Special Modifier Descriptors** (`gabcPitchModifierSpecial`)
   - Padrão: `[a-npA-NP]r[0-8]`
   - Exemplos: `gr1`, `fr0`, `hr8`
   - Componentes:
     * `gabcPitchModifierSpecialBase`: letra de pitch (Identifier)
     * `gabcPitchModifierSpecialChar`: r (Identifier)
     * `gabcPitchModifierSpecialNumber`: 0-8 (Number)

3. **Pitch+Simple Modifier Descriptors** (`gabcPitchModifierSimple`)
   - Padrão: `[a-npA-NP][qwWvVs~<>=rR.]`
   - Exemplos: `gw` (quilisma), `fv` (virga), `h<` (liquescent), `gr` (punctum cavum)
   - Componentes:
     * `gabcPitchModifierSimpleBase`: letra de pitch (Identifier)
     * `gabcPitchModifierSimpleChar`: modificador (Identifier)

#### Highlighting Visual

| Componente | Vim Highlight | Cor (dark theme) | Cor (light theme) |
|------------|---------------|------------------|-------------------|
| Pitch (base) | Identifier | Azul claro/ciano | Azul escuro |
| Modifier | Identifier | Azul claro/ciano | Azul escuro |
| Number (suffix) | Number | Verde brilhante | Verde |

**Nota**: Pitch e modifier recebem o mesmo highlight (`Identifier`) para aparência unificada, criando um agrupamento visual coeso da combinação pitch+modifier.

#### Justificativa

- **Aparência Unificada**: `pitch+modifier` forma uma unidade visual coesa (nota modificada)
- **Consistência**: Mesmo highlight para componentes relacionados
- **Agrupamento Visual**: Cores idênticas indicam que pitch e modifier funcionam juntos
- **Distinção de Sufixos**: Números destacados separadamente (Number) para clareza

#### Mudanças de Compatibilidade

- **Deprecated**: `gabcOriscus` e `gabcOriscusSuffix` (agora parte de `gabcPitchOriscusDescriptor`)
- **Updated**: `gabcFusionCollective` agora inclui padrões compostos
- **Fallback**: Modificadores standalone continuam funcionando para retrocompatibilidade

#### Exemplos de Uso

```gabc
% Pitch+oriscus
(c4) Te(g)sto(go) o(ho)ris(io)cus.(jo) (::)

% Pitch+quilisma
(c4) Qui(gw)lis(fw)ma(hw) tes(iw)te.(jw) (::)

% Pitch+virga
(c4) Vir(gv)ga(fv) di(hv)rei(iv)ta.(jv) (::)

% Pitch+special modifiers
(c4) Va(gr0)ri(fr1)an(hr2)tes(ir3) (::)

% Mistura de padrões
(c4) Ký(d)ri(eo)e(f) e(gw)lé(a)i(bv)son.(c) (::)
```

#### Testes

Arquivo de teste criado: `test-pitch-modifiers.gabc`
- 10 seções testando todos os padrões
- 100+ exemplos de combinações pitch+modifier
- Testes de fusion collective com padrões compostos
- Casos mistos com múltiplos modificadores

#### Sincronização Cross-Project

Esta feature foi implementada de forma consistente em todos os projetos Gregorio:

- ✅ **gregorio.nvim**: Padrões VimScript + highlighting
- ✅ **vscode-gregorio**: TextMate grammar + captures
- ✅ **tree-sitter-gregorio**: Grammar rules + tokens

---

## Versão 2.0 - 2025-10-18

### Sincronização com vscode-gregorio

#### Headers LaTeX Expandidos

- Adicionados `mode-differentia` e `mode-modifier` à lista de headers com suporte LaTeX
- Total de 19 headers LaTeX (vs 7 anteriormente): +171%
- Série `def-m0` até `def-m9` com highlighting separado para o número

#### Headers Numéricos

- Adicionado highlighting dedicado para valores numéricos em headers:
  * `mode`: modo gregoriano (1-8)
  * `staff-lines`: número de linhas da pauta
  * `initial-style`: estilo da inicial
- Valores destacados como `Number` (verde)

#### NABC Glyph Modifiers

- Suporte estendido para sufixo `0` (anteriormente apenas 1-9)
- Mantém highlighting `SpecialChar` para distinção visual

#### Prepunctis/Subpunctis

- Base codes (`su`/`pp`): `Entity` → `Type` (equivalente a `entity.name.class`)
- Modifiers: Mantém `SpecialChar` para consistência

#### LaTeX Inline

- Melhorado reconhecimento de comandos LaTeX em valores de headers
- Funciona sem necessidade de tags `<v>`

---

## Notas de Upgrade

### De v1.x para v2.1

1. **Nenhuma ação necessária** para arquivos GABC existentes
2. **Opcional**: Revisar arquivos com oriscus (`o`/`O`) para aproveitar novo highlighting
3. **Recomendado**: Atualizar testes para incluir padrões pitch+modifier

### Verificação de Highlighting

Abra `test-pitch-modifiers.gabc` no Neovim/Vim para validar as cores:

```bash
nvim test-pitch-modifiers.gabc
```

Esperado:
- Letras de pitch em **azul claro** (Identifier)
- Modificadores em **azul claro** (Identifier) - mesma cor do pitch
- Números em **verde brilhante** (Number)

---

## Referências

- Issue relacionada: Unificação de padrões GABC/NABC
- Comparação: Similar a `nabcSubPrepunctisDescriptor` (lines 367-385)
- Testes: `test-pitch-modifiers.gabc` (152 linhas, 10 seções)
