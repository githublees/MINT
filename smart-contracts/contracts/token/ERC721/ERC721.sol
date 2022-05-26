// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./extensions/IERC721Metadata.sol";
import "../../utils/Address.sol";
import "../../utils/Context.sol";
import "../../utils/Strings.sol";
import "../../utils/introspection/ERC165.sol";

/**
 * PJT Ⅰ - 과제 1 ERC-721 구현
 * @dev EIP-721을 준수하여 ERC721을 작성합니다.
 * https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard
 */
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // 토큰 이름
    string private _name;

    // 토큰 단위(심볼)
    string private _symbol;

    // 토큰의 소유자
    mapping(uint256 => address) private _owners;

    // 특정 주소 별 토큰 보유 수
    mapping(address => uint256) private _balances;

    // 대리 송금 권한 정보
    mapping(uint256 => address) private _tokenApprovals;

    // 부여된 토큰 operator 및 권한 정보
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev 토큰의 이름과 심볼을 매개변수로 받아 상태 변수에 저장한다.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC165, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     * 특정 주소가 몇 개의 NFT 토큰을 보유하는지 반환한다.
     * 매개변수는 0 주소(address(0)일 수 없다.)
     */
    function balanceOf(address owner)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            owner != address(0),
            "ERC721: balance query for the zero address"
        );
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     * 특정 토큰의 소유자 주소를 반환한다.
     */
    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        address owner = _owners[tokenId];
        require(
            owner != address(0),
            "ERC721: owner query for nonexistent token"
        );
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadate: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. 설정을 하면 각 토큰의 결과 URI는
     * 'baseURI'와 'tokenId'가 연결됩니다. 기본적으로 비어 있으며 하위 계약에서
     * 재정의할 수 있습니다.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     * 토큰 권한은 특정 주소에게 부여한다.
     * NFT의 소유자만 권한을 부여할 수 있어야 한다.
     * 권한이 부여되면 Approval 이벤트를 발생시킨다.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);

        require(to != owner, "ERC721: approval to current owner");
        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     * 토큰의 approve 권한을 가진 주소를 반환한다.
     */
    function getApproved(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        require(
            _exists(tokenId),
            "ERC721: approved query for nonexistent token"
        );

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     * 토큰의 operator를 설정한다.
     * operator 란 특정 소유자의 토큰을 전송할 수 있는 모든 권한을 가지며, 토큰 소유자에 의해서만 권한을 지정할 수 있어야 한다.
     * 함수 호출 시  ApprovalForAll 이벤트를 발생시킨다.
     */
    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {_setApprovalForAll}.
     * 모든 'owner' 토큰에서 동작하도록 'operator' 승인
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     * 특정 주소가 operator 권한을 갖는지 반환한다.
     */
    function isApprovedForAll(address owner, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {_transfer}.
     * 'tokenId'를 'from'에서 'to'로 전송 {transferFrom}과 달리 msg.sender에 제한이 없다.
     *
     * 요구사항:
     * - 'to'는 0 주소가 될 수 없습니다.
     * - 'tokenId' 토큰은 'from'이 소유해야 한다.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(
            ERC721.ownerOf(tokenId) == from,
            "ERC721: transfer from incorrect owner"
        );
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev See {_approve}.
     * 'tokenId'에서 작동하도록 'to' 허용
     * {Approval} 이벤트 발생
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev See {_beforeTokenTransfer}.
     * 토큰 전송 전에 호출되는 후크. 여기에는 minting 및 burning이 포함된다.
     *
     * 호출조건:
     * - 'from'과 'to'가 모두 0이 아닌 경우 'from'의 'tokenId'가 'to'로 전송된다.
     * - 'from'이 0이면 'to'에 대해 'tokenid'가 minting 된다.
     * - 'to'가 0이면 'from'의 'tokenId'가 burning 된다.
     * - 'from'과 'to'는 모두 0이 아니다.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    /**
     * @dev See {_afterTokenTransfer}.
     * 토큰 전송 후에 호출되는 후크. 여기에는 minting 및 burning이 포함된다.
     *
     * 호출조건:
     * - 'from'과 'to'는 모두 0이 아니다.
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}. NFT 전송 함수
     * 1. 송금을 지시할 수 있는 대상은 NFT의 소유 당사자(ownerOf()), 승인 받은 주소, 지정된 관리자 주소이다.
     * 2. tokenId가 유효한 토큰인지 확인할 수 있어야 한다.
     * 3. 받는 주소가 0 주소가 아닌지 확인한다.
     * 위 조건이 맞다면, 함수 내부에서 _balances와 _owners 정보를 변경하고 Transfer 이벤트를 발생시킨다.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transger caller is not owner nor approved"
        );
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev See {_safeTransfer}.
     * 'tokenId' 토큰을 'from'에서 'to'로 안전하게 전송하고, 먼저 계약 수신자가 ERC721 프로토콜을 알고 있는지 확인하여
     * 토큰이 영구적으로 잠기는 것을 방지.
     *
     * '_data'는 추가 데이터로 지정된 형식이 없으며 'to'를 호출하여 전송된다.
     * 이 내부 함수는 {safeTransferFrom}과 동일하며 예를 들어 서명 기반과 같은 토큰 전송을 수행하는 대체 메커니즘을 구현한다.
     *
     * 요구사항 :
     * - 'from'은 0 주소가 될 수 없다.
     * - 'to'는 0 주소가 될 수 없다.
     * - 'tokenId' 토큰이 존재해야 하며 'from'이 소유해야 한다.
     * - 'to'가 스마트 컨트렉트를 의미하는 경우 안전한 전송을 위해 호출되는 {IERC721Receiver-onERC721Received}를 구현해야 한다.
     *
     * {Transfer} 이벤트를 발생시킨다.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(
            _checkOnERC721Received(from, to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev See {_checkOnERC721Received}.
     * 대상 주소에서 {IERC721Receiver-onERC721Received}를 호출하는 내부 함수.
     * 대상 주소가 컨트렉트가 아닌 경우 호출되지 않는다.
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC721Receiver(to).onERC721Received(
                    _msgSender(),
                    from,
                    tokenId,
                    _data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC721: transfer to non ERC721Receiver implementer"
                    );
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev See {_isApprovedOrOwner}.
     * 'spender'가 'tokenId'를 관리할 수 있는지 여부를 반환한다.
     *
     * 요구사항 :
     * - 'tokenId'가 있어야 한다.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        virtual
        returns (bool)
    {
        require(
            _exists(tokenId),
            "ERC721: operator query for nonexistent token"
        );

        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner ||
            isApprovedForAll(owner, spender) ||
            getApproved(tokenId) == spender);
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev 'tokenId'를 발행하고 'to'로 전송합니다.
     *
     * WARNING:
     * 이 방법은 사용하지 않는 것이 좋다. 가능하면 {_sateMint}를 사용.
     *
     * 요구사항:
     * - `tokenId`는 존재하지 않아야 한다.
     * - `to`는 0 주소가 될 수 없다.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev 'tokenId를 소각(삭제)하는 함수.
     *
     * 요구사항:
     * - `tokenId`는 존재해야 한다.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }
}
